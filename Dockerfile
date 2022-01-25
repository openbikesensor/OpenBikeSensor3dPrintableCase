from tiangolo/uvicorn-gunicorn
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y openscad make
ADD . /case
ADD customizer /app
RUN pip3 install -e /app/
ENV MODULE_NAME=obs_case_customizer.app