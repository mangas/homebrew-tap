class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.22.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-aarch64-darwin"
      sha256 "a312c15f9ccf67c9d470e0be033750e62129cff5686d2503218a1291d6d2d1ef"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-x86_64-linux"
      sha256 "83492116873ef5f78bab41a9d2b59632b34ab334b5cd6ebdeb1e26e9ac16a481"
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
