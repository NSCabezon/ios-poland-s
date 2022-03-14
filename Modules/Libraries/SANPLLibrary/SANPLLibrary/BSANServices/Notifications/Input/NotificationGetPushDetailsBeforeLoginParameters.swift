//
//  NotificationGetPushDetailsBeforeLoginParameters.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 02/03/2022.
//

import Foundation

public struct NotificationGetPushDetailsBeforeLoginParameters: Encodable {
    let deviceId: Int
    let loginId: Int

    public init(deviceId: Int, loginId: Int) {
        self.deviceId = deviceId
        self.loginId = loginId
    }
}
