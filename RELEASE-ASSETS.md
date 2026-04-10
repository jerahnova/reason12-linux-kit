# Release Assets

The packaged Wine archive should be published as a release asset, not committed to git.

Primary release asset:
- `wine-11.6.tar.zst`

SHA-256:
- `bae5692755c329f9c41578e9eca90baff4ba6c476244b19f669e6cd5365821ea  wine-11.6.tar.zst`

Recommended git-tracked contents:
- `README.md`
- `STATE.txt`
- `install-kit.sh`
- `bootstrap-prefix.sh`
- `archive-commands.sh`
- `export/*`
- `bottle/*`
- `RELEASE-ASSETS.md`
- `SHA256SUMS`

Recommended release payload:
- git repository contents
- `wine-11.6.tar.zst` as a GitHub release asset
