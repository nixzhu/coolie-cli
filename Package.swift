import PackageDescription

let package = Package(
    name: "coolie-cli",
    dependencies: [
        .Package(url: "https://github.com/nixzhu/Coolie.git", majorVersion: 1)
    ]
)
