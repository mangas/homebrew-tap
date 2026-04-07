class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-aarch64-darwin"
      sha256 "c7dac91290952fd32b99afb036da9d4c111774a255307d450a42a48d84582c7d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-x86_64-linux"
      sha256 "887f4d9d065389583e75b4e9f57a38dd40818543f694425d20bf362d67ca7725"
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
