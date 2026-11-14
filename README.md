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

1. Tag the app repo: `git tag v0.1.0 && git push origin v0.1.0`.
2. Add the stable source to `Formula/contui.rb`:
   `url "https://github.com/adgan/contui/archive/refs/tags/v0.1.0.tar.gz"` with the sha256
   from `curl -sL <url> | shasum -a 256`. Keep the `head` block.
3. Build and launch it from the stable URL: `brew install --build-from-source adgan/tap/contui`.
   `brew install adgan/tap/contui` must now work without `--HEAD`.
4. `brew bottle adgan/tap/contui`; upload the bottle to a release named `bottles` in this
   repository and paste the generated bottle block (with `root_url` pointing at that
   release) into the formula. The bottle is arm64-only by design (the design targets
   Apple silicon; Intel builds are untested), so do not advertise one for Intel.
5. Add `Casks/contui.rb` only once the app is Developer ID-signed and notarized; a cask
   wrapping an ad-hoc, unnotarized bundle is blocked by Gatekeeper after download. If
   notarization is out of scope, skip the cask and keep the formula as the install path.
   When it exists, change this README's install line to
   `brew install --cask adgan/tap/contui`.
6. Tick Task 10 in the app repo's plan, `docs/superpowers/plans/2026-11-14-contui.md`.
