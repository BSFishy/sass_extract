# Releasing sass_extract

This whole process is configured in the [Grinder configuration file](tool/grind.dart).

## Release Preparation

Before cutting a release, some prep work needs to be done. This involves 2 main things:
1. Bump the package version in [`pubspec.yaml`](pubspec.yaml)
2. Update the [`CHANGELOG.md`](CHANGELOG.md)

The first part is fairly self-explanatory, just set the `version` property in [`pubspec.yaml`](pubspec.yaml) to the correct version being released.

To update the `CHANGELOG.md`, identify what PR's went into this release, and move them into a section with the header matches the version in `pubspec.yaml`.

## Automatic

The main way to release sass_extract is through the [Release GitHub action](https://github.com/BSFishy/sass_extract/actions/workflows/release.yml).
Simply creating a tag kicks off this process, which creates a [GitHub Release](https://github.com/BSFishy/sass_extract/releases), as well as a release on [NPM](https://www.npmjs.com/package/sass-extract-dart).

To kick off a release, might look like:

```commandline
~$ git tag 1.0.0
~$ git push --tags
```

While the actual tag value doesn't technically matter, it's best to keep it equal to whatever is in [`pubspec.yaml`](pubspec.yaml).

## Manual

The [release workflow](.github/workflows/release.yml) automatically releases, however if you want to manually release, that's an option too.
The brunt of the process is handled by [Grinder](https://pub.dev/packages/grinder) and [`cli_pkg`](https://pub.dev/packages/cli_pkg).

You can kick off a release by running the following commands

```commandline
~$ dart run grinder pkg-github-all
~$ dart run grinder pkg-github-fix-permissions
~$ dart run grinder pkg-npm-deploy
```

### Creating a GitHub Release

```commandline
~$ dart run grinder pkg-github-all
```

This command will create a release on GitHub using the version specified in [`pubspec.yaml`](pubspec.yaml).
It will fill the description with the section of the [`CHANGELOG.md`](CHANGELOG.md) that matches the version in [`pubspec.yaml`](pubspec.yaml).

The `GITHUB_TOKEN` environment variable needs to be set to a valid bearer token.

### Fixing Permissions in GitHub Release

```commandline
~$ dart run grinder pkg-github-all
```

This is a security step outlined here: https://sass-lang.com/blog/security-alert-tar-permissions/

Essentially, this just fixes the permissions of executable files in the GitHub release to prevent security risks.

The `GITHUB_TOKEN` environment variable needs to be set to a valid bearer token.

### Uploading to NPM

```commandline
~$ dart run grinder pkg-npm-deploy
```

This command will generate an NPM package using the version specified in [`pubspec.yaml`](pubspec.yaml).
This process is fully automated, and generates API bindings as well as an executable in the NPM package.

The `NPM_TOKEN` environment variable needs to be set to a valid NPM access token.
