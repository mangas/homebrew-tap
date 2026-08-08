class GctlMcp < Formula
  desc "MCP server for graphctl - exposes Graph network data to AI assistants"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.8.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-aarch64-darwin"
      sha256 "4f71626424aab09dec53614b2facf038a1b32f88e4c89750bfe7031b2b537328"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-x86_64-linux"
      sha256 "8848aed857672a3605661c58365a38e70e24118baf2479b894af3ef8333941f5"
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
