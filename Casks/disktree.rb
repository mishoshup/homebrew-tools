cask "disktree" do
  version "0.11.0"

  on_arm do
    sha256 "942f2508fbbbd6901f796494492b16250d52227155b0ab59f6a5a446b033600b"
    url "https://github.com/tobi/disktree/releases/download/v#{version}/disktree-#{version}-aarch64-macos.zip"
  end
  on_intel do
    sha256 "16ddba6c3d983651cb6389d1c7fd6a070ba443aafcf03c2bc857e35e73b43f4d"
    url "https://github.com/tobi/disktree/releases/download/v#{version}/disktree-#{version}-x86_64-macos.zip"
  end

  name "disktree"
  desc "Treemap for finding and removing what fills your disk"
  homepage "https://github.com/tobi/disktree"

  livecheck do
    url "https://github.com/tobi/disktree/releases/latest"
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "disktree.app"

  # Upstream ships unsigned, unnotarized builds; Homebrew sets the quarantine
  # flag on them, so Gatekeeper would refuse the first launch of every install
  # and upgrade. Clear it here instead of asking the user to.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/disktree.app"]
  end

  caveats <<~EOS
    For accurate scans give disktree Full Disk Access in
    System Settings › Privacy & Security, then reopen the app.
  EOS
end
