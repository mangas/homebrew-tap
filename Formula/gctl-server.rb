class GctlServer < Formula
  desc "Server daemon for graphctl, listening for NATS requests"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.8.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-aarch64-darwin"
      sha256 "e9bf571f95a1cc4068cfc85c42db372b38d19c5b78821b72590e32b69253d9b7"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-x86_64-linux"
      sha256 "16a56d80183d0dfed6a810fbee03c9ba0e99c2819ee6f907b29d5a0fb423b6e5"
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
