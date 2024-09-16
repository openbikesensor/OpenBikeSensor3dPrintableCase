FROM tiangolo/uvicorn-gunicorn-fastapi
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y openscad make fonts-open-sans
ADD . /case
RUN pip3 install -e /case/customizer/
ENV LOG_LEVEL=info
ENV CUSTOMIZER_THREADS=6
ENV MODULE_NAME=obs_case_customizer.app