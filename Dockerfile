from tiangolo/uvicorn-gunicorn-fastapi
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y openscad make
ADD . /case
RUN pip3 install -e /case/customizer/
ENV LOG_LEVEL=info
ENV MODULE_NAME=obs_case_customizer.app