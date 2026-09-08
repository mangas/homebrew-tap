class GctlServer < Formula
  desc "Server daemon for graphctl, listening for NATS requests"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.10.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-aarch64-darwin"
      sha256 "55dd4789c8bc766ed777c0344ca072d3dd8846c71031daaed2b787157a89cd43"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-server-x86_64-linux"
      sha256 "6bfa2ec70c44acdf30162df202a75d2373014f47ab7d8734831fc5dcd64fb98d"
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
