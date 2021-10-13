//
//  NotificationsHandler.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import Commons
import Models
import CorePushNotificationsService
import NotificationCenter

final public class NotificationsHandler: NSObject {
    private var services = [String: NotificationsServiceProtocol]()
    private let dependencies: DependenciesResolver
    private var queuedNotification: PLNotification?

    public required init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - NotificationsHandlerProtocol
extension NotificationsHandler: NotificationsHandlerProtocol {

    public func startServices() {
        services.forEach { $0.value.start() }
    }

    public func addService(_ notificationService: NotificationsServiceProtocol) {
        self.services.updateValue(notificationService, forKey: notificationService.serviceIdentifier)
    }

    public func serviceWithIdentifier(_ identifier: String) -> NotificationsServiceProtocol? {
        return self.services.first(where: {$0.key == identifier})?.value
    }

    public func registeredServicesClasses() -> [String]? {
        return services.compactMap({String(describing: type(of: $0.self))})
    }

    public func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
    }

    public func registerNotificationReceived(userInfo: [AnyHashable: Any], date: Date) {
        self.queuedNotification = NotificationsFactory.createNotification(SystemNotification.userInfo(userInfo),
                                                                            date: date.toLocalTime())
    }

    public func tokenForServiceIdentifier(_ identifier: String, completion: @escaping ((String?, Error?)->Void)) {
        let service = self.services.first(where: { $0.value.serviceIdentifier == identifier })?.value
        service?.getToken(completion: completion)
    }
}

// MARK: - NotificationsHandleRegistrable
extension NotificationsHandler: NotificationsHandlerRegistrable {
    public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        debugPrint("Did register with deviceToken: \(deviceToken)")
    }

    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        debugPrint("Did fail to register with error \(error)")
    }
}

// MARK: - PushNotificationsExecutorProtocol
extension NotificationsHandler: PushNotificationsExecutorProtocol {
    public func executeNotificationReceived() {
        //TODO: Should do something with self.queuedNotification
    }

    public func scheduledNotification() -> PushRequestable? {
        return self.queuedNotification
    }

    public func removeScheduledNotifications(forType type: PushExecutableType){}
}


// MARK: - UNUserNotificationCenterDelegate
extension NotificationsHandler: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                        -> Void) {
        let parsedNotification = NotificationsFactory.createNotification(SystemNotification.notification(notification),
                                                                         date: notification.date.toLocalTime())
        services.forEach {
            if $0.value.shouldInteractWithNotification(parsedNotification) {
                $0.value.willPresentNotification(parsedNotification, with: completionHandler)
            }
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let parsedNotification = NotificationsFactory.createNotification(SystemNotification.response(response),
                                                                         date: response.notification.date.toLocalTime())
        services.forEach {
            if $0.value.shouldInteractWithNotification(parsedNotification) {
                $0.value.didReceiveNotification(parsedNotification, with: completionHandler)
            }
        }
    }
}
