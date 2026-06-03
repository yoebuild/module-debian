load("@core//classes/image.star", "image")

# Debian dev-image: the base-image closure plus a diagnostic and
# editor userland so the device is usable for actual work over SSH.
# Mirrors the spirit of module-alpine's dev-image (htop, strace, less,
# file, curl, etc.) using Debian's apt-side equivalents.
image(
    name = "dev-image",
    distro = "debian",
    artifacts = [
        # base-image closure
        "linux-image-amd64",
        "systemd-sysv",
        "systemd-resolved",
        "init",
        "libc6",
        # dpkg/boot essentials the custom variant won't pull implicitly
        # (dash=/bin/sh, diffutils=diff, libc-bin=ldconfig, base-*=/etc)
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
        # NetworkManager is the connection manager for Debian device
        # images (wifi/cellular targets). It self-enables via its
        # postinst and auto-DHCPs unmanaged ethernet, so the wired QEMU
        # NIC comes up with no connection profile. Replaces the
        # unconfigured ifupdown/isc-dhcp-client that never brought the
        # NIC up. See docs/specs/2026-06-03-debian-device-networking.md.
        "network-manager",
        # dev additions
        "ca-certificates",
        "curl",
        "less",
        "file",
        "htop",
        "strace",
        "procps",
        "iproute2",
        "vim-tiny",
    ],
)
