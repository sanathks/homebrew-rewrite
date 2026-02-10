class Rewrite < Formula
  desc "System-wide text rewriting powered by local LLMs"
  homepage "https://github.com/sanathks/rewrite"
  url "https://github.com/sanathks/rewrite/releases/download/v1.1.2/Rewrite.zip"
  sha256 "5a1c689b9e120acff1b246a46ab6865953591998c57295ff4430aa6ef4c41b1f"
  version "1.1.2"
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
      # Homebrew strips the top-level dir from the zip, so we're inside Rewrite.app/
      app = prefix/"Rewrite.app/Contents"
      (app/"MacOS").mkpath
      (app/"Resources").mkpath

      (app/"MacOS").install "Contents/MacOS/Rewrite"
      app.install "Contents/Info.plist"
      (app/"Resources").install "Contents/Resources/AppIcon.icns"
      (app/"PkgInfo").write "APPL????"
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
