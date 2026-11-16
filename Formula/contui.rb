# typed: false
# frozen_string_literal: true

class Contui < Formula
  desc "Fast native Docker client for macOS"
  homepage "https://github.com/adgan/contui"
  url "https://github.com/adgan/contui/releases/download/v0.3.1/contui-0.3.1.tar.gz"
  sha256 "aa4347e37e55974a9e5af440eb963d79cedf32c5bfcac0acf27bcec6669247ef"
  license "MIT"

  head "https://github.com/adgan/contui.git", branch: "main"

  bottle do
    root_url "https://github.com/adgan/contui/releases/download/v0.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "62a68012b62e055e59763bc7bb418080e6f5f122c63b5a97faa18a9e5f2cc903"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "cargo", "install", *std_cargo_args

    app = buildpath/"contUI.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    mv prefix/"bin/contui", app/"Contents/MacOS/contUI"
    if (buildpath/"assets/Info.plist").exist?
      cp "assets/Info.plist", app/"Contents/Info.plist"
    end
    if (buildpath/"assets/contUI.icns").exist?
      cp "assets/contUI.icns", app/"Contents/Resources/contUI.icns"
    end
    %w[fonts icons].each do |dir|
      cp_r "assets/#{dir}", app/"Contents/Resources/" if (buildpath/"assets/#{dir}").exist?
    end

    system "codesign", "--force", "--deep", "--sign", "-", app
    prefix.install app
    bin.install_symlink prefix/"contUI.app/Contents/MacOS/contUI" => "contui"
  end

  def caveats
    <<~EOS
      contUI installs as an app bundle. To launch it from Finder or Spotlight:
        ln -sf #{opt_prefix}/contUI.app /Applications/contUI.app

      The bundle is ad-hoc signed and not notarized, so the first launch may
      need right-click → Open.
    EOS
  end

  test do
    assert_predicate prefix/"contUI.app/Contents/MacOS/contUI", :executable?
  end
end
