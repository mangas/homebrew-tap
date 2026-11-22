class GctlServer < Formula
  desc "Server daemon for graphctl, listening for NATS requests"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.22.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-server-aarch64-darwin"
      sha256 "5c513373085801f2cc9fbf9081ab86eefbe34131f0b405945d75d91c0003a898"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-server-x86_64-linux"
      sha256 "ce74ab8c2f9c1bd737a6918c0238d8e46350bc9bd6e521c06aa8fd66fc13227f"
    end
  end

  def install
    binary = Dir["gctl-server-*"].first || "gctl-server"
    bin.install binary => "gctl-server"
  end

  test do
    assert_match "Run the server in daemon mode", shell_output("#{bin}/gctl-server --help")
  end
end
