//
//  NotificationStatus.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 15/02/2022.
//

import CoreFoundationLib

public enum NotificationStatus: String, Codable, CaseIterable {
    case delivered = "delivered"
    case read = "read"
    case deleted = "deleted"
    case sent = "sent"
    
    public func getLabel() -> String{
        switch self {
        case .delivered, .sent:
            return localized("pl_alerts_text_unreadCheckBox")
        case .read:
            return localized("pl_alerts_text_readCheckBox")
        default:
            return ""
        }
    }
    
    public static func getFilerList() -> [NotificationStatus]{
        return [.delivered,.read]
    }
}
