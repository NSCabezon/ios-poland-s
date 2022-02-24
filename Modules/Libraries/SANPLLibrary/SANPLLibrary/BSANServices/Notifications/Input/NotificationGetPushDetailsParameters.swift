//
//  NotificationGetPushDetailsParameters.swift
//  SANPLLibrary
//
//  Created by 185860 on 14/02/2022.
//

import Foundation

public struct NotificationGetPushDetailsParameters: Encodable {
    let pushId: Int

    public init(pushId: Int) {
        self.pushId = pushId
    }
}
