#!/bin/bash
# Package an existing arm64 Syphon.framework as a versioned SwiftPM binary package.
# Usage: bash prepare-package.sh [path/to/Syphon.framework]
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
FRAMEWORK="${1:-$HOME/Documents/Syphon.framework}"
REPOSITORY="${GITHUB_REPOSITORY:-josiahshank16/Syphon-MacOS-SPM}"
VERSION="${SYPHON_PACKAGE_VERSION:-v1.0.0}"

if [[ ! -d "$FRAMEWORK" || ! -f "$FRAMEWORK/Syphon" ]]; then
  echo "ERROR: Syphon.framework not found at: $FRAMEWORK" >&2
  echo 'Try bash prepare-package.sh "/full/path/to/Syphon.framework"' >&2
  exit 1
fi

if ! xcodebuild -version >/dev/null 2>&1; then
  echo 'ERROR: Terminal is not using full Xcode.' >&2
  echo 'Open Xcode → Settings → Locations → Command Line Tools, and select Xcode.' >&2
  exit 1
fi

if ! xcrun lipo -archs "$FRAMEWORK/Syphon" | grep -qw arm64; then
  echo 'ERROR: This Syphon framework does not contain arm64.' >&2
  exit 1
fi

STAGING="$HERE/.build-syphon"
XCFRAMEWORK="$STAGING/Syphon.xcframework"
ZIP="$HERE/Syphon.xcframework.zip"
rm -rf "$STAGING"
mkdir -p "$STAGING"
rm -f "$ZIP"

echo "Using source framework: $FRAMEWORK"
echo 'Creating Syphon.xcframework...'
xcodebuild -create-xcframework -framework "$FRAMEWORK" -output "$XCFRAMEWORK"

echo 'Creating ZIP...'
ditto -c -k --sequesterRsrc --keepParent "$XCFRAMEWORK" "$ZIP"
CHECKSUM="$(swift package compute-checksum "$ZIP")"

cat > "$HERE/Package.swift" <<SWIFT
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SyphonMacOSSPM",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Syphon", targets: ["Syphon"])
    ],
    targets: [
        .binaryTarget(
            name: "Syphon",
            url: "https://github.com/$REPOSITORY/releases/download/$VERSION/Syphon.xcframework.zip",
            checksum: "$CHECKSUM"
        )
    ]
)
SWIFT

printf '\nSUCCESS! Generated:\n%s\n%s\n' "$HERE/Package.swift" "$ZIP"
printf 'GitHub release tag: %s\nChecksum: %s\n' "$VERSION" "$CHECKSUM"
echo 'Upload Package.swift to the repository and attach Syphon.xcframework.zip to a GitHub Release with the matching tag.'
