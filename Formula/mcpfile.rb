class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.3.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/mcpfile/v#{version}/mcpfile-aarch64-darwin"
      sha256 "120bc96095a62cdc2157a40396dd7d43526fae807808b56d435e7c809a762037"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/mcpfile/v#{version}/mcpfile-x86_64-linux"
      sha256 "f94bc39548931ff1e4014002651cbf0d79b4ce2bd9e7b14ca031e83b97b9a9d3"
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
