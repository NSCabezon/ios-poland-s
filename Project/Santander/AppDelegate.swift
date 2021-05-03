//
//  AppDelegate.swift
//  Santander

import UIKit
import RetailLegacy
import Commons

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var legacyAppDelegate: RetailLegacyAppDelegate?
    private let appDependencies = AppDependencies()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dependenciesEngine = appDependencies.dependencieEngine
        self.legacyAppDelegate = RetailLegacyAppDelegate(dependenciesEngine: dependenciesEngine)
        let localAppConfig = dependenciesEngine.resolve(for: LocalAppConfig.self)
        let drawer = BaseMenuViewController(isPrivateSideMenuEnabled: localAppConfig.privateMenu)
        application.applicationSupportsShakeToEdit = false
        self.window = UIWindow()
        self.window?.rootViewController = drawer
        self.window?.makeKeyAndVisible()
        self.legacyAppDelegate?.application(application, didFinishLaunchingWithOptions: launchOptions)
        AppNavigationDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine).registerDependencies()
        return true
    }
}
