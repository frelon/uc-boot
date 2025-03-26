FROM registry.opensuse.org/opensuse/tumbleweed:latest AS build

RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends systemd-boot udev efibootmgr kernel-default && \
    dracut -f --regenerate-all && \
    cp -L /boot/* / && \
    SYSTEMD_RELAX_ESP_CHECKS=yes bootctl --graceful --no-variables --esp-path=/ install

COPY tumbleweed.conf /loader/entries/tumbleweed.conf

CMD ["bash"]

FROM registry.opensuse.org/opensuse/tumbleweed:latest AS system

RUN zypper --non-interactive --gpg-auto-import-keys install --no-recommends systemd-boot udev efibootmgr

COPY --from=build /vmlinu* /boot
COPY --from=build /initrd-* /boot
COPY --from=build /config-* /boot
COPY --from=build /System.map-* /boot
COPY --from=build /EFI /boot/EFI
COPY --from=build /loader /boot/loader
