class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-aarch64-darwin"
      sha256 "PLACEHOLDER"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-x86_64-linux"
      sha256 "PLACEHOLDER"
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
