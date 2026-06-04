load("@core//classes/image.star", "image")
load("//classes/kernel.star", "debian_kernel")

# Minimal bootable Debian image. The artifact set is the smallest
# closure that boots in QEMU and accepts an SSH login: kernel, init
# system (systemd via systemd-sysv), libc6, coreutils, bash, dpkg/apt,
# openssh-server, and a DHCP client. Expand per project as the device's
# runtime requirements grow; the Alpine sibling is module-alpine's
# base-image.
#
# The rootfs is assembled with `mmdebstrap --variant=custom`, which
# installs exactly this closure and its hard dependencies — no implicit
# Essential/Priority base. That keeps the image minimal but means the
# packages dpkg itself needs at configure time must be listed
# explicitly: dash (/bin/sh for maintainer scripts), diffutils (diff
# for conffile handling), libc-bin (ldconfig), and the base-files /
# base-passwd that seed /etc. Without them mmdebstrap aborts with
# "expected programs not found in PATH".
image(
    name = "base-image",
    distro = "debian",
    artifacts = [
        debian_kernel(),
        "systemd-sysv",
        "systemd-resolved",
        "init",
        "libc6",
        # dpkg/boot essentials the custom variant won't pull implicitly
        "libc-bin",
        "base-files",
        "base-passwd",
        "dash",
        "diffutils",
        "coreutils",
        "bash",
        "dpkg",
        "apt",
        "openssh-server",
        # NetworkManager: connection manager for Debian device images.
        # Self-enables via postinst and auto-DHCPs unmanaged ethernet,
        # so the wired NIC comes up with no profile. Replaces the
        # unconfigured ifupdown/isc-dhcp-client. See
        # docs/specs/2026-06-03-debian-device-networking.md.
        "network-manager",
    ],
)
