class CodeHiit < Formula
  desc "High-Intensity Interval Training for your typing skills"
  homepage "https://dlm.github.io/code-hiit/"
  version "0.1.0-alpha.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-darwin-arm64"
      sha256 "" # Will be updated automatically on release
    else
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-darwin-amd64"
      sha256 "" # Will be updated automatically on release
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-linux-arm64"
      sha256 "" # Will be updated automatically on release
    else
      url "https://github.com/dlm/code-hiit/releases/download/v#{version}/code-hiit-linux-amd64"
      sha256 "" # Will be updated automatically on release
    end
  end

  def install
    bin.install "code-hiit-darwin-arm64" => "code-hiit" if OS.mac? && Hardware::CPU.arm?
    bin.install "code-hiit-darwin-amd64" => "code-hiit" if OS.mac? && Hardware::CPU.intel?
    bin.install "code-hiit-linux-arm64" => "code-hiit" if OS.linux? && Hardware::CPU.arm?
    bin.install "code-hiit-linux-amd64" => "code-hiit" if OS.linux? && Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-hiit --version")
  end
end
