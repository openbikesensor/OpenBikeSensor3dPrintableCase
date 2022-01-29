import asyncio
import glob
import inspect
import json
import logging
import os
import re
import shutil
import tempfile
import typing
import uuid
import zipfile
from pathlib import Path
from typing import Optional

import pkg_resources
from fastapi import FastAPI, Form, File, Request, Depends, BackgroundTasks
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.responses import RedirectResponse, JSONResponse
from fastapi.templating import Jinja2Templates
from fastapi.websockets import WebSocket
from pydantic import BaseModel
from websockets.exceptions import ConnectionClosed

THREADS = int(os.environ.get('CUSTOMIZER_THREADS', 2))
TIMEOUT = int(os.environ.get('CUSTOMIZER_JOB_TIMEOUT', 600))

# TODO: make this configurable
ALL_PARTS = [
    "Mounting/SeatPostMount",
    "Mounting/BackRiderTopRiderAdapter",
    "Mounting/HandlebarRail",
    "Mounting/BikeRackMountCenterLongitudinal",
    "Mounting/StandardMountAdapter",
    "Mounting/TopTubeMount",
    "Mounting/BikeRackMountSide",
    "Mounting/AttachmentCover",
    "Mounting/BikeRackMountCenter",
    "Mounting/LockingPin",
    "DisplayCase/DisplayCableStrainRelief",
    "DisplayCase/DisplayCaseBottom",
    "DisplayCase/DisplayCaseTop",
    "MainCase/GpsAntennaLid",
    "MainCase/MainCase",
    "MainCase/MainCaseLid",
    "MainCase/UsbCover",
]
ALL_PARTS.extend(
    [f"logo/OpenBikeSensor/MainCase{l}-{inv}-{mn}"
     for l in ["", "Lid"]
     for inv in ["inverted", "normal"]
     for mn in ["main", "highlight"]])

ALL_PARTS = ALL_PARTS[:3]  # for debugging

queue = asyncio.Queue(maxsize=20)
app = FastAPI()
TEMPLATEDIR = pkg_resources.resource_filename(__name__, 'templates')

templates = Jinja2Templates(directory=TEMPLATEDIR)


def field_type(entry, default_value):
    if entry in ["main_case_logo_svg", "main_case_lid_logo_svg"]:
        return "file"
    elif isinstance(default_value, bool):
        return "bool"
    else:
        return "string"


templates.env.filters['field_type'] = field_type


def models(root):
    for root, dirs, files in os.walk(root):
        for f in files:
            yield (Path(root) / f).resolve()


ROOT = Path(os.path.dirname(__file__) + "/../../../")
MODEL_ROOT = (ROOT / "src").resolve()


def scadify(value):
    if isinstance(value, bool):
        return str(value).lower()
    return str(value)


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
            scad_defines.extend(["-D", f"{name}={str(scadify(value))}"])
    return scad_defines


async def run_make_with_params(target_basedir: Path, logfile, targets):
    variables_json_file = target_basedir / "variables.json"
    openscad_options = ["-q"]
    openscad_options.extend(scad_arguments_from_json(variables_json_file))

    command = ["make", "-j", str(THREADS), f"OPENSCAD_OPTIONS={' '.join(openscad_options)}", *targets]

    logfile.open("a").write(" ".join(command) + "\n")

    p = await asyncio.create_subprocess_exec(*command,
                                             stdout=logfile.open("ab"),
                                             stderr=logfile.open("ab"),
                                             cwd=target_basedir)

    await asyncio.wait_for(p.communicate(), TIMEOUT)
    if p.returncode is None:
        p.kill()
        logfile.open("a").write("The conversion took overly long and had to be killed.")
        return False
    if p.returncode:
        logfile.open("a").write("make reported an error.")
        return False
    return True


def copy_custom_logo(from_path: Path, to_path: Path):
    target = to_path / "logo" / "CustomLogo"
    # in case only one logo was uploaded it's replaced by default logo
    shutil.copytree(ROOT / "logo" / "OpenBikeSensor", target)
    if os.path.isfile(from_path / "MainCase.svg"):
        os.unlink(target / "MainCase.svg")
        os.symlink(from_path / "MainCase.svg", target / "MainCase.svg")
    if os.path.isfile(from_path / "MainCaseLid.svg"):
        os.unlink(target / "MainCaseLid.svg")
        os.symlink(from_path / "MainCaseLid.svg", target / "MainCaseLid.svg")


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
                zipped_name = re.sub(r'^export/', 'OpenBikeSensor_customized/', name)
                print("NAME", name, zipped_name)
                zf.write(name, zipped_name)


async def run_job(uid, parts=None):
    if parts == None:
        parts = ALL_PARTS
    dir_to_work = Path(tempfile.gettempdir()) / uid
    logfile = dir_to_work / "log.txt"
    variables_file = dir_to_work / "variables.json"
    job_config = CustomVariables(**json.load(variables_file.open("r")))
    logfile.open("w").write("starting conversion\n")
    info_file = dir_to_work / "info.json"

    info = {
        "parts": parts,
        "status": "working",
    }
    write_info_json = lambda: json.dump(info, info_file.open("wt"))

    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)

        write_info_json()

        await copy_build_files_to_build_dir(dir_to_work, temp, job_config.use_custom_logo)

        logging.error(f" run_job got {dir_to_work}")

        try:
            if job_config.use_custom_logo:
                parts.extend([f"logo/CustomLogo/MainCase{l}-{inv}-{mn}"
                              for l in ["", "Lid"]
                              for inv in ["inverted", "normal"]
                              for mn in ["main", "highlight"]])
                info["parts"] = parts
                write_info_json()

            make_targets = [f'export/{name}.stl' for name in parts]

            project_success = await run_make_with_params(temp, logfile, make_targets)

            package_to_zip(temp / "export", dir_to_work / "OpenBikeSensor_customized.zip")

            logfile.open("a").write(f"conversion completed {'with some errors' if not project_success else ''}\n")
            logfile.open("a").write(f'<BR><A HREF=../download/{uid}.zip>Download here</a>')

            info['status'] = 'complete'
            write_info_json()

        except Exception as e:
            logfile.open("a").write(f"conversion failed with error: {e}")
            logfile.open("a").write(f'<BR><A HREF=../download/{uid}.zip>Download zip anyway</a>')
            logging.exception(f"Failed to process job {uid}")

            info['status'] = 'error'
            write_info_json()

            raise


async def copy_build_files_to_build_dir(dir_to_work: Path, build_dir: Path, use_custom_logo: bool):
    os.symlink(build_dir, dir_to_work / "temp")
    logging.info(f" run_job got {dir_to_work} go")
    shutil.copy(dir_to_work / "variables.json", build_dir / "variables.json")
    try:
        shutil.copytree(ROOT / "src", build_dir / "src", copy_function=os.symlink)
        shutil.copytree(ROOT / "lib", build_dir / "lib", copy_function=os.symlink)
        shutil.copytree(ROOT / "logo", build_dir / "logo", copy_function=os.symlink)
        os.symlink(ROOT / "Makefile", build_dir / "Makefile")
        os.symlink(ROOT / "variables.scad", build_dir / "variables.scad")
    except:
        logging.exception(f"messed up copying {build_dir}")
    if use_custom_logo:
        copy_custom_logo(dir_to_work, build_dir)


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
    use_custom_logo: bool = True
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


class RunningJob(CustomVariables):
    uid: str


@app.get("/")
def form_get(request: Request):
    variables = CustomVariables()
    fields = [("main_case_logo_svg", ""), ("main_case_lid_logo_svg", ""), *variables.dict().items()]
    return templates.TemplateResponse('customizer.html', context={'request': request, 'fields': fields})


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

    temp = Path(tempfile.gettempdir()) / str(uid)
    logfile = temp / "log.txt"
    info_file = temp / "info.json"

    while True:
        log = logfile.open("r").read()
        info = json.load(info_file.open("rt"))

        if info['status'] == 'complete':
            completed = info['parts']
        else:
            completed = [
                re.sub(r'.*/([^/]+/[^/]+\.stl)$', "\g<1>", c)
                for c in glob.glob(f"{temp / 'temp' / 'export'}/**/*.stl", recursive=True)
            ]

        progress = (len(completed) / (len(info['parts']) + 1))

        try:
            await websocket.send_json({
                **info,
                "log": log,
                "completed": completed,
                "progress": progress,
            })
        except ConnectionClosed:
            break

        await asyncio.sleep(1)


@app.post("/job")
async def form_post(request: Request,
                    background_tasks: BackgroundTasks,
                    main_case_logo_svg: Optional[bytes] = File(None),
                    main_case_lid_logo_svg: Optional[bytes] = File(None),
                    variables: CustomVariables = Depends(CustomVariables.as_form)):
    uid = str(uuid.uuid4())
    work_dir = Path(tempfile.gettempdir()) / uid
    logging.info(work_dir)
    work_dir.mkdir(parents=True, exist_ok=True)
    if variables.use_custom_logo is True:
        if len(main_case_logo_svg) > 0:
            logo = work_dir / "MainCase.svg"
            logo.open("wb").write(main_case_logo_svg)
        if len(main_case_lid_logo_svg) > 0:
            logo = work_dir / "MainCaseLid.svg"
            assert (len(main_case_lid_logo_svg) > 100)
            logo.open("wb").write(main_case_lid_logo_svg)
        if len(main_case_logo_svg) == 0 and len(main_case_lid_logo_svg) == 0:
            variables.use_custom_logo = False
    variables_json_file = work_dir / "variables.json"
    variables_json_file.open("w").write(variables.json())
    background_tasks.add_task(run_job, uid)

    if "Accept" in request.headers and request.headers["Accept"] == "application/json":
        return JSONResponse(RunningJob(uid=uid, **variables.dict()).dict())

    return RedirectResponse(f"/job/{uid}", status_code=303)
