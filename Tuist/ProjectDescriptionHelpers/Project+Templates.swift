import Foundation
import ProjectDescription
import UtilityPlugin

public extension Project {
    static func framework(name: String,
                          organizationName: String = "minsone",
                          deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "13.0", devices: .iphone),
                          targets: Set<FeatureTarget> = Set([.staticframework, .tests, .example, .testing]),
                          packages: [Package] = [],
                          dependencies: [TargetDependency] = []) -> Project {

        let hasDynamicFramework = targets.contains(.dynamicframework)

        var projectTargets: [Target] = []
        if targets.contains(where: { $0.hasFramework }) {
            let target = Target(
                name: name,
                platform: .iOS,
                product: hasDynamicFramework ? .framework : .staticFramework,
                bundleId: "kr.minsone.\(name)",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Sources/**/*.swift"],
                resources: hasDynamicFramework ? ["Resources/**"] : [],
                actions: [],
                dependencies: dependencies,
                settings: Settings(base: [:], configurations: XCConfig.framework)
            )


            projectTargets.append(target)
        }

        if targets.contains(.testing) {
            let target = Target(
                name: "\(name)Testing",
                platform: .iOS,
                product: .framework,
                bundleId: "kr.minsone.\(name)Testing",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Testing/Sources/**/*.swift"],
                resources: ["Testing/Resources/**"],
                actions: [],
                dependencies: [
                    .target(name: "\(name)"),
                    // TODO: Testing에 필요한 라이브러리 추가
                ],
                settings: Settings(base: [:], configurations: XCConfig.framework)
            )

            projectTargets.append(target)
        }

        if targets.contains(.tests) {
            /// Framework의 Mach-O가 Static 또는 Dynamic인지에 따라 코드 복사 또는 링킹이 발생하여 상황에 맞게 의존관계를 추가해야함.
            let deps: [TargetDependency]
            switch (hasDynamicFramework, targets.contains(.testing), targets.contains(.example)) {
            case (true, true, true):
                deps = [.target(name: name), .target(name: "\(name)Testing"), .target(name: "\(name)Example")]
            case (true, true, false):
                deps = [.target(name: name), .target(name: "\(name)Testing")]
            case (true, false, true):
                deps = [.target(name: name), .target(name: "\(name)Example")]
            case (false, true, true):
                deps = [.target(name: "\(name)Testing"), .target(name: "\(name)Example")]
            case (false, true, false):
                deps = [.target(name: "\(name)Testing")]
            case (false, false, true):
                deps = [.target(name: "\(name)Example")]
            case (true, false, false), (false, false, false):
                deps = [.target(name: name)]
            }

            let target = Target(
                name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "kr.minsone.\(name)Tests",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/Sources/**/*.swift"],
                resources: ["Tests/Resources/**"],
                actions: [],
                dependencies: [
                    [
                        // TODO: Tests에 필요한 라이브러리 추가
                    ],
                    deps
                ].flatMap { $0 },
                settings: Settings(base: [:], configurations: XCConfig.tests)
            )

            projectTargets.append(target)
        }

        if targets.contains(.example) {

            /// Framework의 Mach-O가 Static 또는 Dynamic인지에 따라 코드 복사 또는 링킹이 발생하여 상황에 맞게 의존관계를 추가해야함.
            let deps: [TargetDependency]
            switch (hasDynamicFramework, targets.contains(.testing)) {
            case (true, true): deps = [.target(name: name), .target(name: "\(name)Testing")]
            case (false, true): deps = [.target(name: "\(name)Testing")]
            case (_, false): deps = [.target(name: name)]
            }

            let target = Target(
                name: "\(name)Example",
                platform: .iOS,
                product: .app,
                bundleId: "kr.minsone.example.\(name)Example",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: [
                    "UIMainStoryboardFile": "",
                    "UILaunchStoryboardName": "LaunchScreen",
                ]),
                sources: ["Example/Sources/**/*.swift"],
                resources: ["Example/Resources/**"],
                actions: [],
                dependencies: [
                    [
                        // TODO: Example에 필요한 라이브러리 추가
                    ],
                    deps
                ].flatMap { $0 },
                settings: Settings(base: [:], configurations: XCConfig.application)
            )

            projectTargets.append(target)
        }

        return Project(
            name: name,
            organizationName: "minsone",
            packages: packages,
            settings: Settings(base: [:], configurations: XCConfig.project),
            targets: projectTargets,
            schemes: [
                Scheme(
                    name: name,
                    shared: true,
                    buildAction: BuildAction(targets: ["\(name)"]),
                    testAction: TestAction(
                        targets: [
                            TestableTarget(
                                target: TargetReference(stringLiteral: "\(name)Tests"),
                                parallelizable: true)
                        ],
                        configurationName: "Test",
                        coverage: true),
                    runAction: .init(configurationName: "Test"),
                    archiveAction: .init(configurationName: "Test"),
                    profileAction: .init(configurationName: "Test"),
                    analyzeAction: .init(configurationName: "Test")
                ),
                targets.contains(.example)
                ? Scheme(
                    name: "\(name)Example",
                    shared: true,
                    buildAction: BuildAction(targets: ["\(name)Example"]),
                    testAction: TestAction(
                        targets: [
                            TestableTarget(
                                target: TargetReference(stringLiteral: "\(name)Tests"),
                                parallelizable: true)
                        ],
                        configurationName: "Test",
                        coverage: true),
                    runAction: .init(configurationName: "Test"),
                    archiveAction: .init(configurationName: "Test"),
                    profileAction: .init(configurationName: "Test"),
                    analyzeAction: .init(configurationName: "Test"))
                : nil
            ].compactMap { $0 })
    }
}

private struct XCConfig {
    static let framework: [CustomConfiguration] = [
        .debug(
            name: "Development",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Framework.xcconfig")
        ),
        .debug(
            name: "Test",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Framework.xcconfig")
        ),
        .release(
            name: "QA",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Framework.xcconfig")
        ),
        .release(
            name: "Beta",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Framework.xcconfig")
        ),
        .release(
            name: "Production",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Framework.xcconfig")
        ),
    ]

    static let tests: [CustomConfiguration] = [
        .debug(
            name: "Development",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Base.xcconfig")
        ),
        .debug(
            name: "Test",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Base.xcconfig")
        ),
        .release(
            name: "QA",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Base.xcconfig")
        ),
        .release(
            name: "Beta",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Base.xcconfig")
        ),
        .release(
            name: "Production",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Base.xcconfig")
        ),
    ]
    static let application: [CustomConfiguration] = [
        .debug(
            name: "Development",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Application.xcconfig")
        ),
        .debug(
            name: "Test",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Application.xcconfig")
        ),
        .release(
            name: "QA",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Application.xcconfig")
        ),
        .release(
            name: "Beta",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Application.xcconfig")
        ),
        .release(
            name: "Production",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/iOS/iOS-Application.xcconfig")
        ),
    ]
    static let project: [CustomConfiguration] = [
        .debug(
            name: "Development",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/Base/Projects/Project-Development.xcconfig")
        ),
        .debug(
            name: "Test",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/Base/Projects/Project-Test.xcconfig")
        ),
        .release(
            name: "QA",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/Base/Projects/Project-QA.xcconfig")
        ),
        .release(
            name: "Beta",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/Base/Projects/Project-Beta.xcconfig")
        ),
        .release(
            name: "Production",
            settings: [String: SettingValue](),
            xcconfig: .relativeToRoot("Configurations/Base/Projects/Project-Production.xcconfig")
        ),
    ]
}
