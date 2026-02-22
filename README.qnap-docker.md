# Hitomi Downloader on QNAP (Container Station)

This repository includes a Docker image build for running **Hitomi Downloader (Windows binary)** on a Linux NAS via **Wine + Xvfb**.

## Important Notes

- This image targets `linux/amd64` only. ARM-based QNAP models are not supported by this Dockerfile.
- The image downloads the upstream release archive (`hitomi_downloader_GUI.zip`) during build.
- Because the app is a Windows GUI application, this container runs it on a virtual display (`Xvfb`). Test command-line behavior for your workflow first.

## What Gets Built

- `Dockerfile`: Ubuntu + Wine runtime
- `.github/workflows/docker-ghcr.yml`: builds on every `push`/tag and pushes to GHCR
- `.hitomi-version`: upstream Hitomi Downloader release tag used at build time (default: `v4.2`)

## GitHub / GHCR Setup

1. Push this repository to GitHub.
2. Enable GitHub Actions for the repository.
3. On push/tag, the workflow builds and pushes:
   - `ghcr.io/<github-owner>/hitomi-downloader:<tag>`
   - `ghcr.io/<github-owner>/hitomi-downloader:latest` (default branch only)
4. If you want a different upstream Hitomi version, update `.hitomi-version` and push again.
5. If you push a git tag like `v4.3`, the workflow uses that tag as the upstream release version (tag overrides `.hitomi-version`).

## Pull From QNAP Container Station

Use image:

`ghcr.io/<github-owner>/hitomi-downloader:latest`

If the GHCR package is private, use a GitHub PAT with `read:packages` in Container Station registry login.

## Recommended Volume Mounts (QNAP)

- `/config` : persist Wine prefix and app settings
- `/downloads` : downloaded files
- `/work` : working directory / temp inputs

Example host paths (change to your NAS paths):

- `/share/Container/hitomi/config` -> `/config`
- `/share/Downloads/hitomi` -> `/downloads`
- `/share/Container/hitomi/work` -> `/work`

## Environment Variables

- `TZ=Asia/Seoul` (optional, recommended)

## Example docker run (for testing on Linux host)

```bash
docker run --rm -it \
  -e TZ=Asia/Seoul \
  -v ./config:/config \
  -v ./downloads:/downloads \
  -v ./work:/work \
  ghcr.io/<github-owner>/hitomi-downloader:latest
```

## Container Station Usage Notes

- For one-off downloads, pass app arguments in the container command/args field (depends on your Hitomi Downloader version and usage pattern).
- First boot may take longer because Wine initializes `/config/wine`.
- If the app needs interactive setup, test locally first, then reuse the saved `/config` volume on QNAP.

## Triggering a Build for a Specific Upstream Version

Option 1 (recommended):
- Edit `.hitomi-version` to the upstream release tag (example: `v4.3`) and push.

Option 2:
- Run GitHub Actions `workflow_dispatch` and set `hitomi_version`.
