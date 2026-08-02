class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.5.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-aarch64-darwin"
      sha256 "8f1116f1e230dc3010e1d92a2788919929fa51a9db8d67d78ebccba47203818e"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-x86_64-linux"
      sha256 "9f3aa44a6b785493e7bda1cc7fa720eced57fc5f8ae8103c4201c6e76708c2ec"
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
