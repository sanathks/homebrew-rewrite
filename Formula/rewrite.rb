class Rewrite < Formula
  desc "System-wide text rewriting powered by local LLMs"
  homepage "https://github.com/sanathks/rewrite"
  url "https://github.com/sanathks/rewrite.git", tag: "v1.0.0"
  license "MIT"

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app = prefix/"Rewrite.app/Contents"
    (app/"MacOS").mkpath
    (app/"Resources").mkpath

    (app/"MacOS").install ".build/release/Rewrite"
    app.install "Resources/Info.plist"
    (app/"Resources").install "Resources/AppIcon.icns"
    (app/"PkgInfo").write "APPL????"
  end

  def caveats
    <<~EOS
      Rewrite has been installed to:
        #{prefix}/Rewrite.app

      To use it, link it to your Applications folder:
        ln -sf #{prefix}/Rewrite.app ~/Applications/Rewrite.app

      You will need to grant Accessibility permissions on first launch.
      Requires Ollama running locally (https://ollama.com).
    EOS
  end
end
