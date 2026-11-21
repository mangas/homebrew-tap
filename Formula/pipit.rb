class Pipit < Formula
  desc "Starlark script engine"
  homepage "https://git.tofus.wtf/fa/pipit"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-darwin"
      sha256 "f43cbdad20b616690eaa514da4080987ddd0b3284c57a3600416df4811d477fb"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-x86_64-linux"
      sha256 "c99c1e590b63aed5d925c5a56d8ec402a94f4aaf00bc3ffd0cda507b3bbbd97e"
    end
    on_arm do
      url "https://releases.tofus.wtf/pipit/v#{version}/pipit-aarch64-linux"
      sha256 "d082c22861eafaf3824453aead64c69d047f9052e8d888823892e1edffd6e191"
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
