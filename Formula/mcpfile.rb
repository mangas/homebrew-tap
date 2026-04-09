class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-aarch64-darwin"
      sha256 "1db4be099b346a2e49decbe9ac3fbb0745572497919b24c37de3fe372258f2ab"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-x86_64-linux"
      sha256 "dac416d8005098686930dac4de2e720f77a50e2da486d85d708fe563a3046ffc"
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
