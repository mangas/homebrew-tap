class Mcpfile < Formula
  desc "Declarative MCP server manager for Docker-based MCP servers"
  homepage "https://github.com/mangas/mcpfile"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-aarch64-darwin"
      sha256 "6fdc0ddf99fa89723428b8bcd2a7f750a23b7f6da19e93ef9d9a2be762525e87"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/mangas/mcpfile/releases/download/mcpfile-v#{version}/mcpfile-x86_64-linux"
      sha256 "67a32a18dbe9ec999c9d655a05d9676e99f7555a14e2004698b3608d5eda0030"
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
