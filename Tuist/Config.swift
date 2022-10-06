import ProjectDescription

let config = Config(
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
