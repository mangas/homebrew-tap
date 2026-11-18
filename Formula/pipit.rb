class Pipit < Formula
  desc "Starlark script engine"
  homepage "https://git.tofus.wtf/fa/pipit"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-darwin"
      sha256 "9a3b135985d8443adf9d940e349d00b0242979ce2dc78ca8ac250a4e4916ff42"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-x86_64-linux"
      sha256 "953db4a4a47a28393623bdac860979863c8471143024350fd7b1bfa06b9cb4f3"
    end
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-linux"
      sha256 "132af68ecbb6024b3b874cce43cff481ad36f46f96dc556484e4e61324cd4a23"
    end
  end

  def install
    binary = Dir["pipit-*"].first || "pipit"
    bin.install binary => "pipit"
  end

  test do
    assert_match "pipit #{version}", shell_output("#{bin}/pipit --version")
  end
end
