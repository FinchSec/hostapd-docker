# hostapd and wpa_supplicant container

Docker for https://w1.fi/hostapd/. Rebuilt daily.

## Pulling

### DockerHub

[![Docker build and upload](https://github.com/FinchSec/hostapd-docker/actions/workflows/docker.yml/badge.svg?event=push)](https://github.com/FinchSec/hostapd-docker/actions/workflows/docker.yml)

URL: https://hub.docker.com/r/finchsec/hostapd

`sudo docker pull finchsec/hostapd`

## Running

`sudo docker run --rm -it --privileged --net=host finchsec/hostapd`
