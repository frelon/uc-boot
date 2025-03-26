FROM registry.opensuse.org/opensuse/tumbleweed:latest AS build

RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends systemd-boot udev efibootmgr kernel-default

COPY cmdline /usr/lib/kernel/cmdline

RUN rm -rf /boot/* && \
    rm -rf /boot/.* && \
    SYSTEMD_ESP_PATH=/boot SYSTEMD_RELAX_ESP_CHECKS=yes bootctl --graceful --no-variables install && \
    SYSTEMD_ESP_PATH=/boot SYSTEMD_RELAX_ESP_CHECKS=yes kernel-install add-all && \
    sed -i 's/\/boot//g' /boot/loader/entries/*.conf

CMD ["bash"]
