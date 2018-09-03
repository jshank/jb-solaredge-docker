FROM ubuntu:16.04
MAINTAINER jshank@theshanks.net

ENV LANG C.UTF-8
ENV MONITOR_IFACE rename2
ENV INVERTER_IP 10.1.10.199
ENV MQTT_SERVER 10.1.10.2

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python \ 
    python-pip \
    vim \
    git \
    tcpdump

# tcpdump HACK around https://github.com/dotcloud/docker/issues/5490
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Git and install solaredge python scripts
RUN git clone https://github.com/jbuehl/solaredge.git
WORKDIR /solaredge
RUN pip install -r requirements.txt

# Install paho-mqtt if you are using se2mqtt.py
RUN pip install paho-mqtt

# Make our persistant data directory
RUN mkdir data
VOLUME /solaredge/data

# Uncomment one of the two lines below, depending on which method 
# you are using to store your data

#CMD tcpdump -i $MONITOR_IFACE -s 65535 -w - tcp and host $INVERTER_IP  | python /solaredge/semonitor.py -vvv | tee /solaredge/data/output.json | python /solaredge/conversion/se2state.py -i /solaredge/data/output.json -o /solaredge/data/solar.json
CMD tcpdump -i $MONITOR_IFACE -s 65535 -w - tcp and host $INVERTER_IP | python /solaredge/semonitor.py -vvv | python /solaredge/conversion/se2MQTT.py -c solaredge -u solaredge -p 'sup3rs3cret' -s $MQTT_SERVER -t tele/solaredge
