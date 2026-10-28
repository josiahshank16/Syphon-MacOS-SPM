# Syphon for Swift Package Manager (macOS)

An **unofficial macOS Swift package wrapper** for [Syphon](https://github.com/Syphon/Syphon-Framework). This makes it possible for an Xcode project to download a prebuilt Syphon XCFramework as a package dependency rather than linking to a local Documents folder.

## Current status

This is a starter repository. The `Package.swift` manifest and a versioned `Syphon.xcframework.zip` release still need to be generated from the already-working framework on the maintainer's Mac. **Do not add this repository as a dependency until those files and the release exist.**

## Requirements

- Apple Silicon (arm64) Mac
- Full Xcode installed and selected for command-line tools
- A working compiled `Syphon.framework` at `~/Documents/Syphon.framework`

The existing source framework targets macOS 14.0 or later. Intel builds are not included.

## Prepare the package

Run the included `prepare-package.sh` in Terminal. It wraps the existing Syphon framework in an XCFramework, ZIPs it, computes its SwiftPM checksum, and writes `Package.swift` pointing to a versioned GitHub release asset. It does not rebuild Syphon or modify the original framework.

The script generates:

- `Package.swift`: commit this file to the GitHub repository.
- `Syphon.xcframework.zip`: **attach this file to a GitHub Release**, not to the repository source files.

## Publish the first release

1. Upload the generated `Package.swift` at the repository root and commit.
2. Select **Releases → Draft a new release**.
3. Create tag `v1.0.0` targeting `main`.
4. Attach `Syphon.xcframework.zip` as the release asset and publish.

The release tag and asset filename must match the generated `Package.swift`. Do not edit the binary after generating its checksum.

## Use with Xcode

In the app's Xcode project, select **Project → Package Dependencies → +** and add:

`https://github.com/josiahshank16/Syphon-MacOS-SPM`

Choose version `1.0.0` and the `Syphon` library product. Remove the old manually referenced framework and its Documents-based Framework Search Path to avoid duplicate linkage. Keep `import Syphon` in your Swift files, build, and verify that `Syphon.framework` is bundled under `VirtualDisplayCamera.app/Contents/Frameworks` after export.

## Notes

This is an unofficial redistributable of Syphon and is not maintained by the original Syphon team. See `LICENSE-Syphon.txt` for upstream copyright and license notices. Verify licensing and system compatibility before distributing updates.
