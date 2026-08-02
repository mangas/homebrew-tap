class GctlServer < Formula
  desc "Server daemon for graphctl, listening for NATS requests"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.5.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-aarch64-darwin"
      sha256 "31163a0af393736f5be4ef9064be2aba2308f1e386c8b115145e69b15313d06a"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-x86_64-linux"
      sha256 "a7533e4a6ac2e7ea7449db1342d58dc5bd5c90dc12ace2d1f9069cd9058dcbb8"
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
