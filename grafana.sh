#!/bin/bash

(
cd $(dirname $0)
set -x
CONF_DIR=$PWD/grafana-config
podman run --name grafana --detach \
    -p 3000:3000 \
    --env "GF_INSTALL_PLUGINS=yesoreyeram-infinity-datasource" \
    -v "$CONF_DIR/grafana.ini:/etc/grafana/grafana.ini" \
    -v "$CONF_DIR/datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml" \
    grafana/grafana:latest
)
