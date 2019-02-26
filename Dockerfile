FROM            ubuntu:16.04
MAINTAINER      Aidil Putra <aidil@nusa.id>
LABEL           Description="Prometheus Openstack Exporter docker image"

RUN             apt-get update \
                && apt-get install -y python-neutronclient python-novaclient python-keystoneclient \
                && apt-get install -y python-netaddr python-cinderclient python-prometheus-client \
                && apt-get install -y python-pip python-dateutil \
                && mkdir -p /var/cache/prometheus-openstack-exporter/ \
                && mkdir -p /etc/prometheus

VOLUME          /etc/prometheus
EXPOSE          9183

COPY            ./prometheus-openstack-exporter.yaml /etc/prometheus/
COPY            ./prometheus-openstack-exporter /
COPY            ./keystonerc_admin /etc/prometheus/
COPY            ./prometheus-openstack-exporter.yaml /etc/prometheus/

RUN             chmod 755 /etc/prometheus \
                && chmod 777 /var/cache/prometheus-openstack-exporter

CMD             . /etc/prometheus/keystonerc_admin \
                && /prometheus-openstack-exporter /etc/prometheus/prometheus-openstack-exporter.yaml
