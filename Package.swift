// swift-tools-version:5.9
import PackageDescription

// The versioned GitHub Release contains a ZIP whose root is Syphon.xcframework.
let package = Package(
    name: "SyphonMacOSSPM",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Syphon", targets: ["Syphon"])
    ],
    targets: [
        .binaryTarget(
            name: "Syphon",
            url: "https://github.com/josiahshank16/Syphon-MacOS-SPM/releases/download/v1.0.0/Syphon.xcframework.zip",
            checksum: "22cf92d039d74b12b92dff0a13c7ad6c810ff7ebac048ddf24dbe1c3c53d57fa"
        )
    ]
)
