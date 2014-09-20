unix-memory
===========

[![Build Status](https://travis-ci.org/vincenthz/hs-unix-memory.png?branch=master)](https://travis-ci.org/vincenthz/hs-unix-memory)
[![BSD](http://b.repl.ca/v1/license-BSD-blue.png)](http://en.wikipedia.org/wiki/BSD_licenses)
[![Haskell](http://b.repl.ca/v1/language-haskell-lightgrey.png)](http://haskell.org)

Provide access to lowlevel syscalls for memory mapping. typically mmap, munmap, msync, mlock, mprotect, ..

Documentation: [unix-memory on hackage](http://hackage.haskell.org/package/unix-memory)

The goal is to fold the System.Posix.Memory module in the unix package. As the unix package
is tied to ghc, it's not convenient to upgrade the package, so this package can act as a
test ground, and a compatility module for older unix version.

Portability is inherently difficult, but the goal is to support every unixoid (Linux, BSD, MacOSX)
that have mmap style functions. Bug reports and pull requests to improve portability more than welcome.
