class GctlMcp < Formula
  desc "MCP server for graphctl - exposes Graph network data to AI assistants"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.16.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-mcp-aarch64-darwin"
      sha256 "aca9116e45d7852f3ab825328f4e81f0ffe6b1a94063f5a1bf784a57a9eadf02"
    end
  end

  on_linux do
    on_intel do
      url "https://releases.tofus.wtf/graphctl-rs/v#{version}/gctl-mcp-x86_64-linux"
      sha256 "af0aca9a70ddf67cbe05a9eb5bfaee7a604c9c58ccf341a0e398ecaff82c8baf"
    end
  end

  def install
    binary = Dir["gctl-mcp-*"].first || "gctl-mcp"
    bin.install binary => "gctl-mcp"
  end

  test do
    assert_match "MCP server for graphctl", shell_output("#{bin}/gctl-mcp --help")
  end
end
