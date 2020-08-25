import ProjectDescription

let settings = Settings(configurations: [.debug(name: "Debug",
                                                xcconfig: .relativeToCurrentFile("App/SupportingFiles/Configurations/Config.xcconfig")),
                                         .release(name: "Release",
                                                  xcconfig: .relativeToCurrentFile("App/SupportingFiles/Configurations/Config.xcconfig"))
])
let target = Target(name: "TweeMe",
                    platform: .iOS,
                    product: .app,
                    productName: "TweeMe",
                    bundleId: "pl.ywapps.tweeme.app",
                    deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
                    infoPlist: .file(path: .relativeToRoot("TweeMe/App/SupportingFiles/Info.plist")),
                    sources: SourceFilesList(globs: [SourceFileGlob("App/Sources/**"),
                                                     SourceFileGlob("App/SupportingFiles/**")]),
                    resources: [.glob(pattern: "App/**/*.xib"),
                                .glob(pattern: "App/**/*.storyboard"),
                                .glob(pattern: "App/**/*.strings"),
                                .glob(pattern: "App/Resources/**")],
                    actions: [
                        .pre(path: .relativeToRoot("Scripts/rswift.sh"),
                             arguments: [],
                             name: "R.swift",
                             inputPaths: ["$TEMP_DIR/rswift-lastrun"],
                             inputFileListPaths: [],
                             outputPaths: ["App/SupportingFiles/Generated/R.generated.swift"],
                             outputFileListPaths: []),
                        .post(path: .relativeToRoot("Scripts/swiftlint.sh"),
                              arguments: [],
                              name: "Swiftlint"),
    ],
                    dependencies: [
                        .package(product: "Rswift"),
                        ],
                    settings: settings)

let defaultScheme = Scheme(name: "TweeMe",
                           shared: true,
                           buildAction: BuildAction(targets: ["TweeMe"]))

let project = Project(name: "TweeMe",
                      packages: [
                        .package(url: "https://github.com/mac-cain13/R.swift.Library", .upToNextMajor(from: "5.2.0")),
                        .package(url: "https://github.com/mac-cain13/R.swift", .upToNextMajor(from: "5.2.2")),
    ],
                      targets: [target],
                      schemes: [defaultScheme],
                      additionalFiles: [])
