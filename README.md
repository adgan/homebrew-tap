# Homebrew tap for contUI

contUI is a native macOS Docker client written in Rust on GPUI. This tap carries its
formula; the app's source lives at [adgan/contui](https://github.com/adgan/contui).

## Status

HEAD-only, build-from-source, tracking `main`. There is no tagged release yet, so
`brew install adgan/tap/contui` without `--HEAD` is unavailable — Homebrew answers with
the `--HEAD` command. The first build is long: Homebrew installs the Rust toolchain, LLVM
and their dependencies as build dependencies.

## Install

```sh
brew tap adgan/tap
brew trust adgan/tap
brew install --HEAD adgan/tap/contui
```

You need macOS (Apple silicon or Intel) and the Xcode Command Line Tools. Budget a few
gigabytes for the build dependencies and a few minutes for the build.

Homebrew 7 refuses formulae from third-party taps until they are trusted; that is what
`brew trust` is for. On older Homebrew it does nothing.

## Launch

```sh
ln -sf "$(brew --prefix contui)/contUI.app" /Applications/contUI.app
open /Applications/contUI.app
```

The bundle is ad-hoc signed and not notarized, so the first launch may be blocked by
Gatekeeper: right-click the app in Finder and choose **Open** once.

`contui` is also on `PATH` and runs the same binary.

## Upgrade

```sh
brew update
brew reinstall --HEAD adgan/tap/contui
```

## Uninstall

```sh
brew uninstall --force contui
brew untap adgan/tap
rm -f /Applications/contUI.app
```

## Releasing (maintainer)

1. Bump `version` in `contui`'s `Cargo.toml` and `assets/Info.plist`, commit, push `main`.
2. Tag the app repo: `git tag -a vX.Y.Z -m "X.Y.Z" && git push origin vX.Y.Z`.
3. Dispatch the release by hand — nothing runs from the tag alone:
   `gh workflow run release.yml -f version=X.Y.Z`. The Linux job publishes the source
   tarball; the macOS job bottles it and prints the new `Formula/contui.rb` in the run
   summary.
4. Copy that formula into `Formula/contui.rb`, commit, push this tap.
5. `brew uninstall contui && brew install adgan/tap/contui` — expect `Pouring`.

Requires macOS 26 (Tahoe) on Apple Silicon. Other platforms have no bottle.

Add `Casks/contui.rb` only once the app is Developer ID-signed and notarized; a cask
wrapping an ad-hoc, unnotarized bundle is blocked by Gatekeeper after download.
