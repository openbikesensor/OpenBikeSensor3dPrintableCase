import asyncio
import inspect
import json
import logging
import os
import shutil
import tempfile
import typing
import uuid
import zipfile
from pathlib import Path

import pkg_resources
from fastapi import FastAPI, Form, File, Request, Depends, BackgroundTasks
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.websockets import WebSocket
from pydantic import BaseModel

THREADS = int(os.environ.get('CUSTOMIZER_THREADS', 2))

queue = asyncio.Queue(maxsize=20)
app = FastAPI()
TEMPLATEDIR = pkg_resources.resource_filename(__name__, 'templates')
templates = Jinja2Templates(directory=TEMPLATEDIR)


def models(root):
    for root, dirs, files in os.walk(root):
        for f in files:
            yield (Path(root) / f).resolve()


ROOT = Path(os.path.dirname(__file__) + "/../../../")
MODEL_ROOT = (ROOT / "src").resolve()


def scad_arguments_from_json(json_file: Path):
    """
    makes a list of "-D <variable> <value>" for openscad as customizer json does not work with includes
    :param json_file:
    :return:
    """
    data = json.load(json_file.open())
    cv = CustomVariables()
    scad_defines = []
    for name, value in data.items():
        if cv.dict()[name] != value:
            scad_defines.extend(["-D", f"{name}={str(value)}"])
    return scad_defines


async def run_make_with_params(target_basedir: Path, logfile):
    variables_json_file = target_basedir / "variables.json"
    openscad_options = ["-q"]
    openscad_options.extend(scad_arguments_from_json(variables_json_file))

    logfile.open("a").write(" ".join(["make", "-j2", f"\"OPENSCAD_OPTIONS={' '.join(openscad_options)}\""]))
    try:
        p = await asyncio.create_subprocess_exec("make", "-j", THREADS, f"OPENSCAD_OPTIONS={' '.join(openscad_options)}",
                                                 stdout=logfile.open("ab"),
                                                 stderr=logfile.open("ab"),
                                                 cwd=target_basedir)

        out, err = await p.communicate()
        logfile.open("ab").write(out + err)

    except:
        logging.exception("dang")


def copy_sources_to(dir: Path):
    try:
        shutil.copytree(ROOT / "src", dir / "src", copy_function=os.symlink)
        shutil.copytree(ROOT / "lib", dir / "lib", copy_function=os.symlink)
        shutil.copytree(ROOT / "logo", dir / "logo", copy_function=os.symlink)
        os.symlink(ROOT / "Makefile", dir / "Makefile")
        os.symlink(ROOT / "variables.scad", dir / "variables.scad")
    except:
        logging.exception(f"messed up copying {dir}")


def package_to_zip(source: Path, target: Path):
    os.chdir(os.path.dirname(source))
    with zipfile.ZipFile(target,
                         "w",
                         zipfile.ZIP_DEFLATED,
                         allowZip64=True) as zf:
        for root, _, filenames in os.walk(os.path.basename(source), followlinks=True):
            for name in filenames:
                name = os.path.join(root, name)
                name = os.path.normpath(name)
                zf.write(name, name)


async def run_job(uid):
    dir_to_work = Path(tempfile.gettempdir()) / uid
    logfile = dir_to_work / "log.txt"
    variables_file = dir_to_work / "variables.json"
    json.load(variables_file.open("r"))
    logfile.open("w").write("starting conversion\n")
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)
        logging.error(f" run_job got {dir_to_work} go")
        shutil.copy(dir_to_work / "variables.json", temp / "variables.json")
        copy_sources_to(temp)
        logging.error(f" run_job got {dir_to_work}")
        project_success = await run_make_with_params(temp, logfile)

        package_to_zip(temp / "export", dir_to_work / "OpenBikeSensor_customized.zip")

        logfile.open("a").write(f"conversion completed {'with some errors' if not project_success else ''}\n")
        logfile.open("a").write(f'<BR><A HREF=../download/{uid}.zip>Download here</a>')


# from https://github.com/tiangolo/fastapi/issues/2387#issuecomment-731662551
def as_form(cls: typing.Type[BaseModel]):
    """
    Adds an as_form class method to decorated models. The as_form class method
    can be used with FastAPI endpoints
    """
    new_params = [
        inspect.Parameter(
            field.alias,
            inspect.Parameter.POSITIONAL_ONLY,
            default=(Form(field.default) if not field.required else Form(...)),
        )
        for field in cls.__fields__.values()
    ]

    async def _as_form(**data):
        return cls(**data)

    sig = inspect.signature(_as_form)
    sig = sig.replace(parameters=new_params)
    _as_form.__signature__ = sig
    setattr(cls, "as_form", _as_form)
    return cls


@as_form
class CustomVariables(BaseModel):
    use_custom_logo: bool = False
    MainCase_back_rider: bool = True
    MainCase_top_rider: bool = True
    MainCase_back_rider_cable: bool = True
    MainCase_top_rider_cable: bool = True
    m3_screw_diameter_tight: float = 3
    m3_screw_diameter_loose: float = 3.25
    m3_hex_nut_diameter: float = 6
    SeatPostMount_angle: float = 20
    SeatPostMount_diameter: float = 28
    SeatPostMount_length: float = 20
    HandlebarRail_tube_radius: float = 18
    DisplayCaseTop_pcb_width: float = 26.5
    DisplayCaseTop_pcb_height: float = 27.2
    DisplayCaseTop_pcb_standoff: float = 1.7
    extrude_width: float = 0.46
    enable_easy_print: bool = True
    layer_height: float = 0.2
    default_clearance: float = 0.2
    orient_for_printing: bool = True


@app.get("/")
def form_get(request: Request):
    variables = CustomVariables()
    return templates.TemplateResponse('customizer.html', context={'request': request, 'fields': variables.dict()})


@app.get("/job/{uid}", response_class=HTMLResponse)
async def job(request: Request, uid: uuid.UUID):
    return templates.TemplateResponse('job.html', context={'request': request, 'uuid': uid})


@app.get("/download/{uid}.zip", response_class=FileResponse)
async def job(request: Request, uid: uuid.UUID):
    filename = Path(tempfile.gettempdir()) / str(uid) / "OpenBikeSensor_customized.zip"
    return FileResponse(filename)


@app.websocket("/jobstate/{uid}")
async def jobstate(websocket: WebSocket, uid: uuid.UUID):
    await websocket.accept()
    logfile = Path(tempfile.gettempdir()) / str(uid) / "log.txt"
    while True:
        l = logfile.open("r").read().replace("\n", "<br/>")
        await websocket.send_json(l)
        await asyncio.sleep(5)


@app.post("/model")
async def form_post(background_tasks: BackgroundTasks, file: bytes = File(...),
                    variables: CustomVariables = Depends(CustomVariables.as_form)):
    uid = str(uuid.uuid4())
    work_dir = Path(tempfile.gettempdir()) / uid
    logging.info(work_dir)
    work_dir.mkdir(parents=True, exist_ok=True)
    if variables.use_custom_logo:
        logo = work_dir / "logo.svg"
        logo.open("wb").write(file)
    variables_json_file = work_dir / "variables.json"
    variables_json_file.open("w").write(variables.json())
    background_tasks.add_task(run_job, uid)
    return RedirectResponse(f"/job/{uid}", status_code=303)
