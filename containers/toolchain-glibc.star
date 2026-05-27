load("@core//classes/container.star", "container")

# toolchain-glibc is the Debian/glibc-side build toolchain. It lives in
# module-debian because it is Debian-side build infrastructure ABI-coupled
# to the Debian release pinned in this module's MODULE.star (_DEBIAN_SUITE)
# and the FROM line in this container's Dockerfile.
#
# provides = ["toolchain"] + distro = "debian" wire this into yoe's
# distro-aware toolchain dispatch (R9 in
# docs/specs/2026-05-25-module-debian.md): classes depend on the virtual
# name "toolchain"; the resolver's provides table finds candidates and the
# per-unit distro compatibility tag (R21a) narrows to the one matching the
# consuming image's effective distro. Debian images see this toolchain;
# Alpine images see toolchain-musl.
#
# The distro and provides fields are inert on yoe core that predates R9's
# landing (unknown kwargs are captured into Unit.Extra and ignored). They
# become load-bearing once internal/starlark/types.go grows the Distro
# field and the closure walker's visibility filter ships.

container(
    name = "toolchain-glibc",
    version = "1",
    description = "Debian-based build toolchain with glibc, gcc, dpkg-dev, apt-utils, and essential build tools",
    provides = ["toolchain"],
    distro = "debian",
)
