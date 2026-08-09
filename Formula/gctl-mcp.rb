class GctlMcp < Formula
  desc "MCP server for graphctl - exposes Graph network data to AI assistants"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.9.0"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-aarch64-darwin"
      sha256 "3dd4c841d428d1b9f5dee0ff3ad6ce947a57ac9ad852756107b8a17c16b85201"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-x86_64-linux"
      sha256 "faaa4df5d15f611834eb1ede2b0ff61f8843dbec2deba685f4dd0e20c70294ff"
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
