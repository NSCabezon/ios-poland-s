//
//  PLPushNotification.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 9/9/21.
//

import CorePushNotificationsService
import CoreFoundationLib

public enum SystemNotification {
    case notification(UNNotification)
    case response(UNNotificationResponse)
    case userInfo([AnyHashable: Any])
}

public struct PLNotification: PushRequestable {
    public var userInfo: [AnyHashable: Any] {
        switch systemNotification {
        case .notification(let note):
            return note.request.content.userInfo
        case .response(let note):
            return note.notification.request.content.userInfo
        case .userInfo(let note):
            return note
        }
    }
    public var date: Date
    public var systemNotification: SystemNotification
    public var didReceiveRequestAction: PushDidReceiveRequestAction? {
        return nil
    }
    public var willPresentRequestAction: PushWillPresentRequestAction? {
        return nil
    }
    public var executableType: PushExecutableType? {
        return nil
    }
}
