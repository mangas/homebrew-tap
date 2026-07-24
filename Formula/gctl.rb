class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.3.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-aarch64-darwin"
      sha256 "2993d95a336a169b8449ec0de411faad1834a8d5a201f40ecf155eff2b9f5466"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-x86_64-linux"
      sha256 "6159245625ae634296d186e1323ed76d3361bad9f7135cba8db98ebf61abe363"
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
