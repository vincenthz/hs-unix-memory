unix-memory
===========

Provide access to lowlevel syscalls for memory mapping. typically mmap, munmap, msync, mlock, mprotect, ..

Documentation: [unix-memory on hackage](http://hackage.haskell.org/package/unix-memory)

The goal is to fold the System.Posix.Memory module in the unix package. As the unix package
is tied to ghc, it's not convenient to upgrade the package, so this package can act as a
test ground, and a compatility module for older unix version.

Portability is inherently difficult, but the goal is to support every unixoid (Linux, BSD, MacOSX)
that have mmap style functions. Bug reports and pull requests to improve portability more than welcome.
