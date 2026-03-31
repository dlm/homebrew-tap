class CodeHiit < Formula
  desc "High-Intensity Interval Training for your typing skills"
  homepage "https://dlm.github.io/code-hiit/"
  version "0.1.0-alpha.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-darwin-arm64"
      sha256 "121814fdbe50d78466e1f53a51bac6809d870c4577d1c8679eea9430e17b40aa"
    else
      odie "Only Apple Silicon (ARM64) is supported on macOS"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-linux-amd64"
      sha256 "8d4d038648fe39ba63bcd000272b3b7e1fdc6e052a462c9987450cb7f5eca763"
    else
      odie "Only AMD64 architecture is supported on Linux"
    end
  end

  def install
    if OS.mac?
      bin.install "code-hiit-darwin-arm64" => "code-hiit"
    elsif OS.linux?
      bin.install "code-hiit-linux-amd64" => "code-hiit"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-hiit --version")
  end
end
