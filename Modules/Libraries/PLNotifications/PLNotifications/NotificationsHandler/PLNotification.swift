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

        var customPushLaunch: CustomPushLaunchActionTypeCapable?

        switch userInfo["openApp"] as? Int {
        case 0:
            if let pushID = userInfo["messageId"] as? Int,
               let devID = userInfo["devId"] as? Int {
                customPushLaunch = CustomPushLaunchActionTypeInfo(messageId: pushID,
                                                                  devId: devID, content: "")
            }

        case 1:
            customPushLaunch = CustomPushLaunchActionTypeBlik()
        case 2:
            if let pushID = userInfo["messageID"] as? Int,
               let devID = userInfo["devId"] as? Int {
                customPushLaunch = CustomPushLaunchActionTypeAlert(messageId: pushID,
                                                                   devId: devID)
            }
        case 3:
            if let devID = userInfo["devId"] as? Int {
                customPushLaunch = CustomPushLaunchActionTypeAuth(devId: devID)
            }
        default:
            debugPrint("invalid openApp: \(userInfo["openApp"])")
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

public struct CustomPushLaunchActionTypeInfo: CustomPushLaunchActionTypeCapable {
    public var messageId: Int
    public var devId: Int?
    public var content: String?
    
    public init(messageId: Int, devId: Int? = nil, content: String? = nil) {
        self.messageId = messageId
        self.devId = devId
        self.content = content
    }
    
    
}

public struct CustomPushLaunchActionTypeBlik: CustomPushLaunchActionTypeCapable {
}

public struct CustomPushLaunchActionTypeAlert: CustomPushLaunchActionTypeCapable {
    var messageId: Int
    var devId: Int
}

public struct CustomPushLaunchActionTypeAuth: CustomPushLaunchActionTypeCapable {
    var devId: Int
}
