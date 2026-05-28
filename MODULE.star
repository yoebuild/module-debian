module_info(
    name = "debian",
    description = "Wraps Debian's main + security + updates package feeds as yoe units, and ships the Debian/glibc-side build toolchain (toolchain-glibc). The Debian release pinned below MUST match the FROM debian:<release> in containers/toolchain-glibc/Dockerfile — packages from these feeds are ABI- and signing-key-coupled to the toolchain libc.",
)

# Each debian_feed() registers a synthetic module named
# "<parent>.<component>", so consumers reference packages via
# "debian.main" / "debian.contrib" in prefer_modules. The suite kwarg
# is feed configuration (it picks which on-disk Packages file is
# parsed); only one Debian suite per project is supported, so it
# doesn't appear in the module identity.
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
_DEBIAN_SUITE = "bookworm"

debian_feed(
    name = "main",
    url = _DEBIAN_MIRROR,
    suite = _DEBIAN_SUITE,
    component = "main",
    arches = ["amd64", "arm64"],
    index = "feeds/main",
    keyring = "keys/debian-archive-keyring.gpg",
)
