import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootNavigationViewController = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: rootNavigationViewController)
        mainCoordinator.start()
        
        window?.rootViewController = mainCoordinator.navigationController
        window?.makeKeyAndVisible()
        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

