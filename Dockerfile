FROM registry.opensuse.org/opensuse/tumbleweed:latest AS build

RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends systemd-boot udev efibootmgr kernel-default && \
    rm -rf /boot/* && \
    rm -rf /boot/.* && \
    dracut -f --regenerate-all && \
    SYSTEMD_ESP_PATH=/boot SYSTEMD_RELAX_ESP_CHECKS=yes bootctl --graceful --no-variables install && \
    SYSTEMD_ESP_PATH=/boot SYSTEMD_RELAX_ESP_CHECKS=yes kernel-install add-all && \
    rm /boot/initrd-*

CMD ["bash"]
