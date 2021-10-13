//
//  NotificationsHandlerProtocol.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import NotificationCenter

// MARK: - NotificationsHandlerProtocol
public protocol NotificationsHandlerProtocol: NotificationsHandlerRegistrable {

    func startServices()

    func addService(_ notificationService: NotificationsServiceProtocol)

    func serviceWithIdentifier(_ identifier: String) -> NotificationsServiceProtocol?

    func registeredServicesClasses() -> [String]?

    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any])

    func registerNotificationReceived(userInfo: [AnyHashable: Any], date: Date)

    func tokenForServiceIdentifier(_ identifier: String, completion: @escaping ((String?, Error?)->Void))
}

public protocol NotificationsHandlerRegistrable {

    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error)
}
