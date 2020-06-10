FROM python:3.6.10-alpine

RUN mkdir -p /opt/paycertify
WORKDIR /opt/paycertify
COPY requirements.txt ./tmp/

RUN apk --no-cache update &&\
    apk --no-cache add -qq `cat tmp/requirements.txt` &&\
    pip3 install pyyaml gitpython &&\
    rm -rf tmp






COPY ci.py .


CMD [ "sh" ]
