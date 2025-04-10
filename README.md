# Homebrew Taps

## Installation

### Specific Formula Cask

To install a specific formula/cask, you can run
```shell
brew install rblenkinsopp/tap/<formula>
```

### Whole Tap

To make all formulas or casks available run
```shell
brew tap rblenkinsopp/tap
brew install <formula>
```

For packages which are older versions of packages in homebrew main, they are set as keg only and need to then be linked with:

```shell
brew link <formula@version>
```

## Packages

This tap contains packages which are not suitable for inclusion in homebrew main.

### Casks

- `perfetto` Homebrew doesn't allow packages which have source to be included as casks. However perfetto is very complicated to build with many dependancies which are not in brew, for the time being this is a cask as precompiled binaries are available.
- `cmake@3` () Homebrew only ships CMake 4+, this is pined at CMake `3.31.x` and is set as keg only.
