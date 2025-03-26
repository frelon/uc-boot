#!/bin/bash -x

set -e

SCRIPT="$(realpath -s "${0}")"
SCRIPT_PATH="$(dirname "${SCRIPT}")"

image=$1

img_mnt=$(podman image mount "${image}") || exit 1

qemu-img create -f raw disk.img 10G
loopdev=$(losetup -f --show disk.img)
sgdisk -og "${loopdev}"
sgdisk -n 1:2048:4194303 -c 1:"EFI System Partition" -t 1:ef00 "${loopdev}"
sgdisk -n 2:4194304:+0 -c 2:"Root System Partition" -t 2:8300 "${loopdev}"
partx -u "${loopdev}"
mkfs.vfat -F 16 -n EFI "${loopdev}p1"
mkfs.ext4 -L SYSTEM "${loopdev}p2"
partx -u "${loopdev}"

workdir=/mnt/efi
srcdir="${img_mnt}"

mkdir -p "${workdir}"
mount "${loopdev}p1" "${workdir}"

cp -r "${srcdir}"/boot/* ${workdir}/

umount "${workdir}"

losetup -D "${loopdev}"
