FROM ubuntu:16.04

ENV LANG C.UTF-8
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y python python-dev python3.5 python3.5-dev python-pip \
    libssl-dev libpq-dev git build-essential libfontconfig1 libfontconfig1-dev vim \
    git tcpdump

# HACK around https://github.com/dotcloud/docker/issues/5490
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump
RUN pip install setuptools pip --upgrade --force-reinstall
RUN git clone https://github.com/jbuehl/solaredge.git
WORKDIR /solaredge
RUN mkdir data
# First run to initialize the solar.json file
# RUN python conversion/se2state.py -i inverter_sample.json -o solar.json
RUN pip install -r requirements.txt
CMD tcpdump -i eno2 -s 65535 -w - 'tcp and host 10.1.10.199'  | python /solaredge/semonitor.py -vvv | tee /solaredge/data/output.json | python /solaredge/conversion/se2state.py -i /solaredge/data/output.json -o /solaredge/data/solar.json
#python solaredge/sekey.py -o 7f101234.key
