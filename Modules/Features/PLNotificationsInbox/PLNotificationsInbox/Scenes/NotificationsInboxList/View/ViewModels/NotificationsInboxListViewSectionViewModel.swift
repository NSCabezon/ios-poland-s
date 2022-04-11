//
//  NotificationsInboxListViewSectionViewModel.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 11/02/2022.
//

import Foundation
import SANPLLibrary

enum NotificationsInboxListViewSectionType {
    case info
    case push
}

struct PLNotificationListSectionViewModel {
    var notification: PLNotificationEntity
    let sendTitleDate: String
}

class NotificationsInboxListViewSectionViewModel {
    var type: NotificationsInboxListViewSectionType
    var list: [PLNotificationListSectionViewModel]?
    var headerName: String?
    
    init(type: NotificationsInboxListViewSectionType, list: [PLNotificationListSectionViewModel], headerName: String? = nil) {
        self.type = type
        self.list = list
        self.headerName = headerName
    }
}

