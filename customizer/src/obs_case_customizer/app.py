import asyncio
import inspect
import logging
import os
import json
import shutil
import tempfile
import typing
import uuid
from pathlib import Path

import pkg_resources
from asyncinotify import Inotify, Mask
from fastapi import FastAPI, Form, File, UploadFile, Request, Depends
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.websockets import WebSocket
from fastapi.responses import HTMLResponse

from pydantic import BaseModel

queue = asyncio.Queue(maxsize=20)
app = FastAPI()
TEMPLATEDIR = pkg_resources.resource_filename(__name__, 'templates')
templates = Jinja2Templates(directory=TEMPLATEDIR)


def models(root):
    for root, dirs, files in os.walk(root):
        for f in files:
            yield (Path(root) / f).resolve()


MODEL_ROOT = Path(os.path.dirname(__file__) + "/../../../src").resolve()


async def convert_scad_file(scad_file: str, dir_to_work: Path):
    logging.error(f"converting {scad_file}")
    logging.info(f"converting {scad_file} in {dir_to_work}")
    variables_json_file = dir_to_work / "variables.json"

    modelfile = MODEL_ROOT / scad_file
    targetfile = dir_to_work / str(scad_file).replace("scad", "stl")
    targetfile.parent.mkdir(parents=True, exist_ok=True)
    assert targetfile.parent.is_dir()
    assert variables_json_file.is_file()
    assert modelfile.is_file()
    p = await asyncio.create_subprocess_exec("openscad",
                                       str(modelfile),
                                       "-p", str(variables_json_file), "-o",
                                       str(targetfile))
    try:
        await asyncio.wait_for(p.wait(), 200)
        return True
    except asyncio.TimeoutError:
        logging.error(f"timeout for {scad_file}")
        return False


async def run_make():
    p = await asyncio.create_subprocess_exec("make",
                                             "-j", cwd=Path(os.path.dirname(__file__)).parent.parent.parent)
    try:
        await asyncio.wait_for(p.wait(), 200)
        return True
    except asyncio.TimeoutError:
        logging.error(f"timeout for")
        return False


async def run_job(dir_to_work):
    logfile = dir_to_work / "log.txt"
    variables_file = dir_to_work / "variables.json"
    json.load(variables_file.open("r"))
    logfile.open("w").write("starting conversion\n")
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)
        logging.error(f" run_job got {dir_to_work} go")
        shutil.copy(dir_to_work / "variables.json", temp / "variables.json")
        logging.error(f" run_job got {dir_to_work}")

        for scad_file in list(models(MODEL_ROOT)):
            logfile.open("a").write(f"converting {scad_file}")
            success = await convert_scad_file(scad_file.relative_to(MODEL_ROOT), temp)
            logfile.open("a").write(f"{'successful' if success else 'failed'}\n")


async def worker():
    logging.info("worker running")
    while True:
        dir_to_work = await queue.get()
        await run_job(dir_to_work)
        queue.task_done()


@app.on_event("startup")
async def start_worker():
    logging.error("statup")
    app.convert_workers = []
    for i in range(3):
        logging.error(f"starting worker {i}")
        app.convert_workers.append(asyncio.create_task(worker()))
        logging.info(f"started worker {i}")


@app.on_event("shutdown")
async def stop_worker():
    for task in app.convert_workers:
        task.cancel()


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
    threshold: float = 0.
    use_custom_logo: bool = False
    MainCase_back_rider: bool = False
    MainCase_top_rider: bool = False
    MainCase_back_rider_cable: bool = False
    MainCase_top_rider_cable: bool = False
    ScrewHole_diameter_M3: float = 0
    HexNutHole_diameter: float = 0
    SeatPostMount_angle: float = 0
    SeatPostMount_diameter: float = 0
    SeatPostMount_length: float = 0
    HandlebarRail_tube_radius: float = 0
    extrude_width: float = 0
    enable_easy_print: bool = False
    layer_height: float = 0
    default_clearance: float = 0


@app.post("/files/")
async def create_file(
        file: bytes = File(...), fileb: UploadFile = File(...), token: str = Form(...)
):
    return {
        "file_size": len(file),
        "token": token,
        "fileb_content_type": fileb.content_type,
    }


@app.get("/")
def form_get(request: Request):
    variables = CustomVariables()
    return templates.TemplateResponse('customizer.html', context={'request': request, 'fields': variables.dict().keys()})


@app.get("/job/{uid}",response_class=HTMLResponse)
async def job(request: Request, uid: uuid.UUID):
    return templates.TemplateResponse('job.html', context={'request': request, 'uuid': uid})

@app.websocket("/jobstate/{uid}")
async def jobstate(websocket: WebSocket, uid: uuid.UUID):
    await websocket.accept()
    logfile = Path(tempfile.gettempdir()) / str(uid) / "log.txt"
    while True:
        l = logfile.open("r").read().replace("\n","<br/>")
        await websocket.send_json(l)
        await asyncio.sleep(5)


@app.post("/model")
async def form_post(file: bytes = File(...), variables: CustomVariables = Depends(CustomVariables.as_form)):
    uid = str(uuid.uuid4())
    work_dir = Path(tempfile.gettempdir()) / uid
    logging.info(work_dir)
    work_dir.mkdir(parents=True, exist_ok=True)
    if variables.use_custom_logo:
        logo = work_dir / "logo.svg"
        logo.open("wb").write(file)
    variables_json_file = work_dir / "variables.json"
    variables_json_file.open("w").write(variables.json())
    await queue.put(work_dir)
    return RedirectResponse(f"/job/{uid}", status_code=303)
