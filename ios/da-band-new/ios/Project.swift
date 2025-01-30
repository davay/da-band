import ProjectDescription

let project = Project(
    name: "ios",
    targets: [
        .target(
            name: "ios",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ios",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ios/Sources/**"],
            resources: ["ios/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "iosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.iosTests",
            infoPlist: .default,
            sources: ["ios/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ios")]
        ),
    ]
)
