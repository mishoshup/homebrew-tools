# homebrew-tools

Personal Homebrew tap.

## disktree

A treemap for finding and removing what fills your disk, by
[tobi](https://github.com/tobi/disktree). macOS builds only — the upstream
project is Linux-first.

```sh
brew tap mishoshup/tools
brew install --cask disktree
brew upgrade            # after the tap picks up a new release
```

`scripts/bump.sh` rewrites the cask from the latest upstream release
(`.github/workflows/autobump.yml` runs it every six hours), so `brew upgrade`
finds new versions without editing anything by hand.

First launch may be blocked because upstream does not sign or notarize its
builds:

```sh
xattr -dr com.apple.quarantine /Applications/disktree.app
```
