class Pipit < Formula
  desc "Starlark script engine"
  homepage "https://git.tofus.wtf/fa/pipit"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-darwin"
      sha256 "8fa2f3151e70d18a2df8fc0832a9d6136c52b290e434c0f8c04665e5c3722b07"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-x86_64-linux"
      sha256 "831e6318b85e56ee7f37b6b1f4a495ddf7174d098f40512c23684a0c86a213b9"
    end
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-linux"
      sha256 "6747952897a457875228ad7ef366c48defe3db26030f4258044b2e35b9796d7e"
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
