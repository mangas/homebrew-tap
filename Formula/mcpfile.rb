class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-aarch64-darwin"
      sha256 "fdb96b7425c48e91ff87853af582361a12896809e34b81459f84027127e218e1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-x86_64-linux"
      sha256 "1dc1e948c2761b64446d376de597adc924510d77a398ce69b3264d01cdfa709c"
    end
  end

  def install
    binary = Dir["mcpfile-*"].first || "mcpfile"
    bin.install binary => "mcpfile"
  end

  test do
    assert_match "Declarative MCP server manager", shell_output("#{bin}/mcpfile --help")
  end
end
