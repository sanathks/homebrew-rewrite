class Rewrite < Formula
  desc "System-wide text rewriting powered by local LLMs"
  homepage "https://github.com/sanathks/rewrite"
  url "https://github.com/sanathks/rewrite/releases/download/v1.0.0/Rewrite.zip"
  sha256 "001b8c63075d651894b47bb9aaf17afcbd23f5196919e8ae72ad8e382a358887"
  version "1.0.0"
  license "MIT"

  head "https://github.com/sanathks/rewrite.git", branch: "main"

  depends_on :macos

  def install
    if build.head?
      system "swift", "build", "-c", "release", "--disable-sandbox"

      app = prefix/"Rewrite.app/Contents"
      (app/"MacOS").mkpath
      (app/"Resources").mkpath

      (app/"MacOS").install ".build/release/Rewrite"
      app.install "Resources/Info.plist"
      (app/"Resources").install "Resources/AppIcon.icns"
      (app/"PkgInfo").write "APPL????"
    else
      prefix.install "Rewrite.app"
    end

    mkdir_p "#{Dir.home}/Applications"
    ln_sf "#{prefix}/Rewrite.app", "#{Dir.home}/Applications/Rewrite.app"
  end

  def post_install
    system "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
           "-f", "#{prefix}/Rewrite.app"
  end

  def caveats
    <<~EOS
      Rewrite has been installed to ~/Applications/Rewrite.app

      You will need to grant Accessibility permissions on first launch.
      Requires Ollama running locally (https://ollama.com).
    EOS
  end
end
