class GctlMcp < Formula
  desc "MCP server for graphctl - exposes Graph network data to AI assistants"
  homepage "https://github.com/mangas/graphctl-rs"
  version "0.5.1"
  license "MIT"

  S3_BUCKET = "https://graphctl-rs-releases.s3.eu-west-3.amazonaws.com"

  on_macos do
    on_arm do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-aarch64-darwin"
      sha256 "2f7c6a2f0dbe94301880c9130554c0db4a6451324f12b964be38c60b51641fb3"
    end
  end

  on_linux do
    on_intel do
      url "#{S3_BUCKET}/graphctl_rs-v#{version}/gctl-mcp-x86_64-linux"
      sha256 "c7450224d85ed60b49bfb8c5c313ceb11798dcf095a915ebeba62fdac12e1b8a"
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
