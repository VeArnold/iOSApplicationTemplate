import ProjectDescription
import ProjectDescriptionHelpers

let project = Project
    .staticFramework(name: "FeatureSettingsUserInterface",
               		 dependencies: [
						.Project.UserInterface.FeatureUserInterfaceComponent,
               		 ])