class GctlMcp < Formula
  desc "MCP server for graphctl - exposes Graph network data to AI assistants"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.11.1"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-aarch64-darwin"
      sha256 "c2e332a4eb9439529a0d170d9d438bff8c957041b74b77cd79487ca4967a7e59"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-x86_64-linux"
      sha256 "5a97785a4e0176a3dbc8073fb25f6cebd139f302fdadc1e6b11cbee8a2db1d45"
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
