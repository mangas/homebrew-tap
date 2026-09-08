class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.10.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-aarch64-darwin"
      sha256 "00682890082ebdc1c387be13c9c7d2ec7dcb19912367fcbdbfd878787d226b7c"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-x86_64-linux"
      sha256 "ce2a16062c41ec55351cb42fd10cc1d89f1e8537ef0b691768ba3a05c14a06f6"
    end
  end

  def install
    binary = Dir["gctl-*"].first || "gctl"
    bin.install binary => "gctl"
  end

  test do
    assert_match "Manage subgraph deployments", shell_output("#{bin}/gctl --help")
  end
end
