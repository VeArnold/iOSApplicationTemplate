import ProjectDescription
import ProjectDescriptionHelpers

let project = Project
    .staticFramework(name: "FeatureLoanUserInterface",
               		 dependencies: [
						.Project.UserInterface.FeatureUserInterfaceComponent,
               		 ])