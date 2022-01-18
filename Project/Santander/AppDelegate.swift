//
//  AppDelegate.swift
//  Santander

import UIKit
import RetailLegacy
import Commons
import PLNotifications
import CoreFoundationLib

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
        let dependenciesEngine = appDependencies.dependencieEngine
        self.legacyAppDelegate = RetailLegacyAppDelegate(dependenciesEngine: dependenciesEngine, coreDependenciesResolver: self)
        let localAppConfig = dependenciesEngine.resolve(for: LocalAppConfig.self)
        let drawer = BaseMenuViewController(isPrivateSideMenuEnabled: localAppConfig.privateMenu)
        application.applicationSupportsShakeToEdit = false
        self.window = UIWindow()
        self.window?.rootViewController = drawer
        self.window?.makeKeyAndVisible()
        self.legacyAppDelegate?.application(application, didFinishLaunchingWithOptions: launchOptions)
        AppNavigationDependencies(drawer: drawer, dependenciesEngine: dependenciesEngine).registerDependencies()
        ModuleDependencies(legacyDependenciesResolver: dependenciesEngine, drawer: drawer)
                    .registerRetailLegacyDependencies()
        notificationsHandler.startServices()

        return true
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.notificationsHandler.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.notificationsHandler.didFailToRegisterForRemoteNotificationsWithError(error)
    }
}

// TODO: Move to ModuleDependency once it is created

extension AppDelegate: LegacyCoreDependenciesResolver, CoreDependenciesResolver {
    func resolve() -> DependenciesResolver {
        return appDependencies.dependencieEngine
    }
    
    func resolve() -> TrackerManager {
        return appDependencies.dependencieEngine.resolve()
    }
    
    func resolve() -> CoreDependencies {
        return coreDependencies
    }
}
