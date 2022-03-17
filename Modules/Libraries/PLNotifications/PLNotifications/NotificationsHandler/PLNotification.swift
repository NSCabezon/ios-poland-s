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
        let gcmAlias = "gcm.notification."
        var customPushLaunch: CustomPushLaunchActionTypeCapable?
        guard
            let str = userInfo[gcmAlias + "openApp"] as? String,
            let openAppInt = Int(str)
        else {
            return nil
        }
        
        switch openAppInt {
        case 0:
            guard
                let messageIdStr = userInfo[gcmAlias + "messageId"] as? String,
                let messageIdInt = Int(messageIdStr),
                let devIdStr = userInfo[gcmAlias + "devId"] as? String,
                let devIdInt = Int(devIdStr)
            else {
                return nil
            }
            customPushLaunch = CustomPushLaunchActionTypeInfo(messageId: messageIdInt, devId: devIdInt)
        case 1:
            guard
                let messageIdStr = userInfo[gcmAlias + "messageId"] as? String,
                let messageIdInt = Int(messageIdStr),
                let devIdStr = userInfo[gcmAlias + "devId"] as? String,
                let devIdInt = Int(devIdStr)
            else {
                return nil
            }
            customPushLaunch = CustomPushLaunchActionTypeBlik(messageId: messageIdInt, devId: devIdInt, content: nil)
        case 2:
            guard
                let messageIdStr = userInfo[gcmAlias + "messageId"] as? String,
                let messageIdInt = Int(messageIdStr),
                let devIdStr = userInfo[gcmAlias + "devId"] as? String,
                let devIdInt = Int(devIdStr)
            else {
                return nil
            }
            customPushLaunch = CustomPushLaunchActionTypeAlert(messageId: messageIdInt, devId: devIdInt, content: nil)
        case 3:
            guard
                let messageIdStr = userInfo[gcmAlias + "messageId"] as? String,
                let messageIdInt = Int(messageIdStr),
                let devIdStr = userInfo[gcmAlias + "devId"] as? String,
                let devIdInt = Int(devIdStr)
            else {
                return nil
            }
            customPushLaunch = CustomPushLaunchActionTypeAuth(messageId: messageIdInt, devId: devIdInt, content: nil)
        default:
            print("invalid openApp: \(String(describing: userInfo[gcmAlias + "openApp"]))")
            return nil
        }

        guard let customPushLaunch = customPushLaunch else {
            return nil
        }

        return PushDidReceiveRequestAction.launchAction(type: .custom(customPushLaunch))
    }

    public var willPresentRequestAction: PushWillPresentRequestAction? {
        return nil
    }
    public var executableType: PushExecutableType? {
        return nil
    }
}

public protocol CustomPushLaunchAction: CustomPushLaunchActionTypeCapable {
    var messageId: Int { get }
    var devId: Int? { get }
    var content: String? { get }
}

public struct CustomPushLaunchActionTypeInfo: CustomPushLaunchAction {
    public let messageId: Int
    public let devId: Int?
    public let content: String?
    
    public init(messageId: Int, devId: Int? = nil, content: String? = nil) {
        self.messageId = messageId
        self.devId = devId
        self.content = content
    }
}

public struct CustomPushLaunchActionTypeBlik: CustomPushLaunchAction {
    public let messageId: Int
    public let devId: Int?
    public let content: String?
}

public struct CustomPushLaunchActionTypeAlert: CustomPushLaunchAction {
    public let messageId: Int
    public let devId: Int?
    public let content: String?
}

public struct CustomPushLaunchActionTypeAuth: CustomPushLaunchAction {
    public let messageId: Int
    public let devId: Int?
    public let content: String?
}
