//
//  AppDelegate.swift
//  Santander

import UIKit
import RetailLegacy
import CoreFoundationLib
import PLNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var legacyAppDelegate: RetailLegacyAppDelegate?
    private let appDependencies = AppDependencies()
    private let coreDependencies = DefaultCoreDependencies()
    private lazy var notificationsHandler: NotificationsHandlerProtocol = {
        appDependencies.dependencieEngine.resolve(for: NotificationsHandlerProtocol.self)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let legacyDependenciesEngine = appDependencies.dependencieEngine
        let localAppConfig = legacyDependenciesEngine.resolve(for: LocalAppConfig.self)
        let drawer = BaseMenuViewController(isPrivateSideMenuEnabled: localAppConfig.privateMenu)
        let moduleDependencies = ModuleDependencies(oldResolver: legacyDependenciesEngine, drawer: drawer)
        _ = AppModifiers(dependencies: moduleDependencies)
        self.legacyAppDelegate = RetailLegacyAppDelegate(dependenciesEngine: legacyDependenciesEngine, coreDependenciesResolver: moduleDependencies)
        application.applicationSupportsShakeToEdit = false
        self.window = UIWindow()
        self.window?.rootViewController = drawer
        self.window?.makeKeyAndVisible()
        self.legacyAppDelegate?.application(application, didFinishLaunchingWithOptions: launchOptions)
        AppNavigationDependencies(drawer: drawer, dependenciesEngine: legacyDependenciesEngine).registerDependencies()
        notificationsHandler.startServices()
        return true
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.notificationsHandler.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.notificationsHandler.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.legacyAppDelegate?.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
