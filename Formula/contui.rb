# typed: false
# frozen_string_literal: true

class Contui < Formula
  desc "Fast native Docker client for macOS"
  homepage "https://github.com/adgan/contui"
  url "https://github.com/adgan/contui/releases/download/v0.1.0/contui-0.1.0.tar.gz"
  sha256 "e26f4de9b342c6325b3461dd762050fc0435fce6f3f6c4cfad2a0f795191b35c"
  license "MIT"

  head "https://github.com/adgan/contui.git", branch: "main"

  bottle do
    root_url "https://github.com/adgan/contui/releases/download/v0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cb85fdd3093fc6c591500d157aba14b6d69690d746de4b923beabe014b1ee6a7"
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
