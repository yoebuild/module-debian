# Debian kernel meta-package selection, shared by this module's images.
#
# Debian ships an arch-specific kernel meta-package — linux-image-amd64 on
# x86_64, linux-image-arm64 on arm64. An image calls debian_kernel() in its
# artifact list so the kernel tracks the build's target arch instead of
# hardcoding one. Centralizing it here means a new arch is wired up by
# editing this one map rather than every image, and it keeps each Debian
# image evaluating cleanly on every host: yoe evaluates all modules' units
# up front, so a hardcoded amd64 kernel would make a Debian image fail to
# resolve even when an Alpine arm64 image is the actual build target.

_KERNEL_BY_ARCH = {
    "x86_64": "linux-image-amd64",
    "arm64": "linux-image-arm64",
}

def debian_kernel():
    """Return the Debian kernel meta-package for the target arch (ctx.arch)."""
    kernel = _KERNEL_BY_ARCH.get(ctx.arch)
    if kernel == None:
        fail("debian_kernel: no kernel package for arch=%s (supported: %s)" %
             (ctx.arch, ", ".join(sorted(_KERNEL_BY_ARCH.keys()))))
    return kernel
