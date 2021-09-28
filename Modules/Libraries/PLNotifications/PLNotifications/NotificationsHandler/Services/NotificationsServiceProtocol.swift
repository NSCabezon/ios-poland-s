//
//  NotificationServiceProtocol.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import CorePushNotificationsService

public typealias NotificationsServiceProtocol = NotificationServiceCapable & NotificationResponseCapable

// MARK: - NotificationServiceCapable
public protocol NotificationServiceCapable {

    func start()

    var serviceIdentifier: String { get }

    func getToken(completion: @escaping ((String?, Error?)->Void))
}

// MARK: - NotificationResponseCapable
public protocol NotificationResponseCapable {

    // Every notification will be passed to all services and it is the service the one deciding if it should handle it
    func shouldInteractWithNotification(_ notification: PLNotification) -> Bool

    func willPresentNotification(_ pushNotification: PLNotification, with completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)

    func didReceiveNotification(_ pushNotification: PLNotification, with completionHandler: @escaping () -> Void)
}
