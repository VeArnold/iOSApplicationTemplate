import UIKit
import FeatureSettingsUserInterface

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SetttingsViewController()
        viewController.view.backgroundColor = .systemRed
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
