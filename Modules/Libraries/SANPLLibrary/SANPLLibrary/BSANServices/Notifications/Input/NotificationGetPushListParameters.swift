//
//  NotificationGetPushListParameters.swift
//  SANPLLibrary
//
//  Created by 185860 on 14/02/2022.
//

import Foundation

public struct NotificationGetPushListParameters: Encodable {
    let deviceId: Int

    public init(deviceId: Int) {
        self.deviceId = deviceId
    }
}
