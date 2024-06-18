//
//  AppDelegate.swift
//  DownloadMultipleFilesTestApp
//

import UIKit
import OSLog


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let logger = Logger(subsystem: "com.mycompany.DownloadMultipleFilesTestApp", category: "SceneDelegate")
    var bgHandlers: [String: () -> Void] = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("didFinishlaunchging with options: \(String(describing: launchOptions?.keys), privacy: .public) at time: \(formatter.string(from: Date()), privacy: .public)")
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        bgHandlers[identifier] = completionHandler
        logger.debug("called handleEventsForBackgroundURLSession for: \(identifier, privacy: .public) at time: \(formatter.string(from: Date()), privacy: .public)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        logger.debug("app will terminate at time: \(formatter.string(from: Date()), privacy: .public)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
