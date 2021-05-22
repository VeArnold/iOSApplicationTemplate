import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project
    .staticLibrary(name: "SwiftPackageMerge",
                   packages: [
                    .alamofire
                   ],
                   dependencies: [
                    .SwiftPM.alamofire
                   ])
