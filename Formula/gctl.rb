class Gctl < Formula
  desc "CLI client for managing Graph network subgraph deployments"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.20.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-aarch64-darwin"
      sha256 "3819e92568c82d5f107992a997188aedc7a3f8611aa68292f33225778d204aeb"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-x86_64-linux"
      sha256 "4a1f0600dce90badeecc80142b23767c60584eb70e41a23c25fca68adcc24907"
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
