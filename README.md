# Homebrew tap for contUI

contUI is a native macOS Docker client written in Rust on GPUI. This tap carries its
formula; the app's source lives at [adgan/contui](https://github.com/adgan/contui).

## Status

0.1.0 is the first tagged release, with a prebuilt bottle for arm64 macOS 26 (Tahoe).
`brew install adgan/tap/contui` pours the bottle — no Rust toolchain, no compile. Other
platforms have no bottle, and the formula refuses to install there.

`--HEAD` still works and still builds from source, for development.

## Install

```sh
brew tap adgan/tap
brew trust adgan/tap
brew install adgan/tap/contui
```

Requires macOS 26 (Tahoe) on Apple Silicon. The build dependencies (Rust, LLVM and their
dependencies, a few gigabytes) are only installed when a bottle is unavailable.

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
brew upgrade contui
```

`brew reinstall --HEAD adgan/tap/contui` rebuilds from `main` if you want the tip.

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
