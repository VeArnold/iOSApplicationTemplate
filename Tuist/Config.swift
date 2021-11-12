import ProjectDescription

let config = Config(
    compatibleXcodeVersions: ["13.0", "13.1"],
    plugins: [
        .local(path: .relativeToRoot("Plugin/UtilityPlugin"))
    ],
    generationOptions: [
        .xcodeProjectName("\(.projectName)"),
        .organizationName("minsone"),
        .disableAutogeneratedSchemes,
        .disableSynthesizedResourceAccessors,
    ]
)
