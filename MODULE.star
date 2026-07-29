module_info(
    name = "debian",
    description = "Wraps Debian's main + contrib + non-free-firmware + non-free package feeds as yoe units, and ships the Debian/glibc-side build toolchain (toolchain-debian-13). All feeds track one release (security/updates are separate suites of that release and not yet supported). The Debian release pinned below MUST match the FROM debian:<release> in containers/toolchain-debian-13/Dockerfile — packages from these feeds are ABI- and signing-key-coupled to the toolchain libc.",
)

# Each apt_feed() registers a synthetic module named
# "<parent>.<component>", so consumers reference packages via
# "debian.main" / "debian.contrib" in prefer_modules. Neither the suite
# nor the codename appears in the module identity.
#
# suite vs codename: `suite` is the dists/<suite> path segment the feed
# fetches from, and `codename` is the release the packages are built
# for. They are the same string for these feeds because they serve the
# base archive directly, but they are not the same kind of value —
# Debian publishes this release at both dists/trixie and dists/stable,
# and a vendor overlay repo may name its channel anything. yoe requires
# every apt feed in a Debian closure to agree on the codename (the libc
# ABI depends on it) while leaving suites free to differ.
# Units materialize lazily as the runtime closure references them —
# declaring a feed costs one Starlark call and ~12 MB of checked-in
# Packages text per arch, not 60k+ .star files.
#
# To refresh the in-tree Packages files from upstream after Debian
# ships a point release or security update, run `yoe update-feeds` in
# this module's root. That fetches each feed's InRelease, verifies the
# signature against the keys/debian-archive-keyring.gpg list, applies
# the R25 fingerprint allow-list to any new key, and atomically
# rewrites feeds/<component>/<arch>/Packages. See docs/module-debian.md
# (planned) for the full maintainer playbook.

_DEBIAN_MIRROR = "https://deb.debian.org/debian"
_DEBIAN_CODENAME = "trixie"

apt_feed(
    name = "main",
    distro = "debian",
    url = _DEBIAN_MIRROR,
    suite = _DEBIAN_CODENAME,
    codename = _DEBIAN_CODENAME,
    component = "main",
    arches = ["amd64", "arm64"],
    index = "feeds/main",
    keyring = "keys/debian-archive-keyring.gpg",
)

apt_feed(
    name = "contrib",
    distro = "debian",
    url = _DEBIAN_MIRROR,
    suite = _DEBIAN_CODENAME,
    codename = _DEBIAN_CODENAME,
    component = "contrib",
    arches = ["amd64", "arm64"],
    index = "feeds/contrib",
    keyring = "keys/debian-archive-keyring.gpg",
)

apt_feed(
    name = "non-free-firmware",
    distro = "debian",
    url = _DEBIAN_MIRROR,
    suite = _DEBIAN_CODENAME,
    codename = _DEBIAN_CODENAME,
    component = "non-free-firmware",
    arches = ["amd64", "arm64"],
    index = "feeds/non-free-firmware",
    keyring = "keys/debian-archive-keyring.gpg",
)

apt_feed(
    name = "non-free",
    distro = "debian",
    url = _DEBIAN_MIRROR,
    suite = _DEBIAN_CODENAME,
    codename = _DEBIAN_CODENAME,
    component = "non-free",
    arches = ["amd64", "arm64"],
    index = "feeds/non-free",
    keyring = "keys/debian-archive-keyring.gpg",
)
