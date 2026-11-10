cask "nit" do
  version "0.1.23"
  sha256 "eaed6bb8ab4313668fadb8c1ebc333cb6cf43b801b613230ff71fe579de40491"

  url "https://releases.tofus.wtf/nit/macos/v#{version}/nit-aarch64-darwin.zip"
  name "nit"
  desc "Pull request review app for GitHub and Forgejo"
  homepage "https://git.tofus.wtf/mintedlabs/nit"

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "nit.app"

  # nit.app is signed ad hoc, not notarized: Gatekeeper refuses it while it
  # carries the quarantine flag the download sets, so the staged copy loses
  # it before it is moved into place.
  preflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "nit.app"], chdir: "."
  end

  caveats <<~EOS
    nit reads its sources from ~/.config/nit/env, e.g.
      NIT_GITHUB_CLIENT_ID=<OAuth App client id>
      NIT_FORGEJO_URL=https://git.example.com
  EOS
end
