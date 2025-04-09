# Homebrew Taps

## Installation

### Specific Formula Cask

To install a specific formula/cask, you can run `brew install rblenkinsopp/tap/<formula>`

### Whole Tap

To make all formulas or casks available run `brew tap rblenkinsopp/tap` and then `brew install <formula>`.

## Packages

This tap contains packages which are not suitable for inclusion in homebrew main.

### Casks

- `perfetto` Homebrew doesn't allow packages which have source to be included as casks. However perfetto is very complicated to build with many dependancies which are not in brew, for the time being this is a cask as precompiled binaries are available.
