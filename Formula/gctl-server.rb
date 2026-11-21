class GctlServer < Formula
  desc "Server daemon for graphctl, listening for NATS requests"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.20.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-server-aarch64-darwin"
      sha256 "4e7b49bc813965e880b9c5d79446aa080bba0d98789a7a1e4aef69bad8bae458"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-server-x86_64-linux"
      sha256 "a23b3dbfae1c6d45fee29b4fd618e10a32042782985262ccefc734c9cc48be51"
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
