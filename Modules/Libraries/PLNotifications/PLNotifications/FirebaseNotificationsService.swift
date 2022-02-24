//
//  FirebaseNotificationService.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import CoreFoundationLib
import CorePushNotificationsService
import FirebaseCore
import FirebaseMessaging
import os

public final class FirebaseNotificationsService: NSObject {
    let dependenciesResolver: DependenciesResolver

    private enum Constants {
        static let serviceName = "Firebase"
    }

    public required init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        super.init()
    }
}

// MARK: - NotificationServiceCapable
extension FirebaseNotificationsService: NotificationServiceCapable {
    public func start() {

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }

    public var serviceIdentifier: String {
        return Constants.serviceName
    }

    public func getToken(completion: @escaping ((String?, Error?)->Void)) {
        self.getFCMToken(callback: completion)
    }
}

// MARK: - NotificationResponseCapable
extension FirebaseNotificationsService: NotificationResponseCapable {

    public func shouldInteractWithNotification(_ notification: PLNotification) -> Bool {
        return true
    }

    public func willPresentNotification (_ pushNotification: PLNotification, with completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }

    public func didReceiveNotification (_ pushNotification: PLNotification, with completionHandler: @escaping () -> Void) {
        Messaging.messaging().appDidReceiveMessage(pushNotification.userInfo)
        dependenciesResolver.resolve(firstOptionalTypeOf: CorePushNotificationsManagerProtocol.self)?.didReceivePushRequest(pushNotification)
        completionHandler()
    }
}

// MARK: - MessagingDelegate
extension FirebaseNotificationsService: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        os_log("✅ [FirebaseNotificationService] Did receive Firebase Messaging Token (FCM TOKEN): %@", log: .default, type: .info, (fcmToken ?? "<< empty >>"))
    }
}

public extension FirebaseNotificationsService {

    private func getFCMToken(callback: @escaping ((String?, Error?)->Void)) {
        Messaging.messaging().token { token, error in
            if let error = error {
                os_log("✅ [FirebaseNotificationService] Error fetching FCM registration token: %@", log: .default, type: .error, error.localizedDescription)
            } else if let token = token {
                os_log("✅ [FirebaseNotificationService] FCM registration token: %@", log: .default, type: .info, token)
            }
            callback(token, error)
        }
    }
}
