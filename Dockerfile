FROM debian:unstable-slim as builder
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install git libnl-3-dev libnl-genl-3-dev libssl-dev gcc libpcsclite-dev \
                    make libc6-dev libsqlite3-dev pkg-config libnl-route-3-dev \
                    libdbus-1-dev libreadline-dev -y --no-install-recommends && \
    apt-get autoclean && \
    rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*
RUN git clone git://w1.fi/hostap.git && cp hostap wpa_supplicant -R

# hostapd
WORKDIR /hostap/hostapd/
COPY hostapd/defconfig defconfig.docker
# Compare defconfig, if different, fail -> We may need to update our config (hostapd)
RUN diff -ur defconfig.docker defconfig
COPY hostapd/config .config
RUN make

# wpa_supplicant
WORKDIR /wpa_supplicant/wpa_supplicant/
COPY wpa_supplicant/defconfig defconfig.docker
# Compare defconfig, if different, fail -> We may need to update our config (wpa_supplicant)
RUN diff -ur defconfig.docker defconfig
COPY wpa_supplicant/config .config
RUN make


FROM debian:unstable-slim
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install libnl-3-200 libnl-genl-3-200 libnl-route-3-200 libdbus-1-3 \
                    libssl3t64 libsqlite3-0 pcscd libreadline8 -y --no-install-recommends && \
    rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*
COPY --from=builder /hostap/hostapd/hostapd /usr/local/bin/
COPY --from=builder /hostap/hostapd/hostapd_cli /usr/local/bin/
COPY --from=builder /wpa_supplicant/wpa_supplicant/wpa_passphrase /usr/local/bin/
COPY --from=builder /wpa_supplicant/wpa_supplicant/wpa_cli /usr/local/bin/
COPY --from=builder /wpa_supplicant/wpa_supplicant/wpa_supplicant /usr/local/bin/