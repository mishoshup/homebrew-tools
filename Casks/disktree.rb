cask "disktree" do
  version "0.10.1"

  on_arm do
    sha256 "90381628fdd0fc5c87aa32ba003ee85f2fb5eb496fab7aa1ee16428aaf7d9eca"
    url "https://github.com/tobi/disktree/releases/download/v#{version}/disktree-#{version}-aarch64-macos.zip"
  end
  on_intel do
    sha256 "9955a0da39630296aef5709114979d79c8eb6f7e045bf67a056e490e1d3c4b96"
    url "https://github.com/tobi/disktree/releases/download/v#{version}/disktree-#{version}-x86_64-macos.zip"
  end

  name "disktree"
  desc "Treemap for finding and removing what fills your disk"
  homepage "https://github.com/tobi/disktree"

  livecheck do
    url "https://github.com/tobi/disktree/releases/latest"
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "disktree.app"

  caveats <<~EOS
    disktree releases are not signed or notarized. If Gatekeeper refuses the
    first launch, clear the quarantine flag once:

      xattr -dr com.apple.quarantine "/Applications/disktree.app"

    For accurate scans give it Full Disk Access in
    System Settings › Privacy & Security, then reopen the app.
  EOS
end
