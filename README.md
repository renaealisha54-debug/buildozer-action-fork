# buildozer-action-fork

A fork of [ArtemSBulgakov/buildozer-action](https://github.com/ArtemSBulgakov/buildozer-action) that fixes a broken JDK 17 install in the Docker build.

## Why this fork exists

The upstream action's `Dockerfile` installs JDK 17 via the `openjdk-r` Launchpad PPA. That PPA no longer publishes packages for newer Ubuntu release codenames (e.g. "resolute"), so `apt update` fails with a 404 and the container build breaks with:

```
Error: The repository 'https://ppa.launchpadcontent.net/openjdk-r/ppa/ubuntu resolute Release' does not have a Release file.
ERROR: process "/bin/sh -c sudo apt update" did not complete successfully: exit code: 100
```

## What changed

- Removed `add-apt-repository ppa:openjdk-r/ppa`
- Removed the PPA-only `apt update`
- Added a plain `apt-get update` (no PPA) immediately before installing `openjdk-17-jdk`, since modern Ubuntu ships JDK 17 in its default repos

## Usage

In a GitHub Actions workflow, reference this fork instead of the original:

```yaml
- name: Build with Buildozer
  uses: renaealisha54-debug/buildozer-action-fork@master
  with:
    buildozer_version: stable
```

All other inputs/outputs are unchanged from upstream — see [action.yml](./action.yml).
