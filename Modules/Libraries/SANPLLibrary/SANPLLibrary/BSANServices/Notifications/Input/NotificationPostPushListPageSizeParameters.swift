//
//  NotificationPostPushListPageSizeParameters.swift
//  SANPLLibrary
//
//  Created by 185860 on 14/02/2022.
//

import Foundation

public struct NotificationPostPushListPageSizeParameters: Encodable {
    public let loginId: Int
    public let deviceId: Int
    public let categories: [EnabledPushCategorie]
    public let statuses: [NotificationStatus]
    public let pushId: Int?
    public let pageSize: Int

    public init(loginId: Int, deviceId: Int, categories: [EnabledPushCategorie], statuses: [NotificationStatus], pushId: Int?, pageSize: Int) {
        self.loginId = loginId
        self.deviceId = deviceId
        self.categories = categories
        self.statuses = statuses
        self.pushId = pushId
        self.pageSize = pageSize
    }
}
