class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.16.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-aarch64-darwin"
      sha256 "adce4dc596913b46ffbc4e5ae493ae1652eea404d03810a2a56872f026fc2d85"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-x86_64-linux"
      sha256 "cee3f9f1cfa9a556bac717f198978cebd3aa53ccd7ae1f3078160db13607f646"
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
