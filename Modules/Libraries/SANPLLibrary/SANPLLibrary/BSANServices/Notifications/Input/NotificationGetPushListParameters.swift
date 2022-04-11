//
//  NotificationGetPushListParameters.swift
//  SANPLLibrary
//
//  Created by 185860 on 14/02/2022.
//

import Foundation

public struct NotificationGetPushListParameters: Encodable {
    let deviceId: Int
    let enabledPushCategories: [EnabledPushCategorie]


    public init(deviceId: Int, enabledPushCategories: [EnabledPushCategorie] = []) {
        self.deviceId = deviceId
        self.enabledPushCategories = enabledPushCategories
    }
}
