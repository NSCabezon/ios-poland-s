//
//  NotificationsInboxListCellViewModel.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 29/12/2021.
//

import Foundation
import UIKit
import SANPLLibrary

enum NotificationType: Int {
    case information = 0
    case alert = 1
    case blik = 2
    case transaction = 3
    
    var image: UIImage? {
        switch self {
        case .information:
            return UIImage(named: "announcmentSymbol", in: .module, compatibleWith: nil)
        case .alert:
            return UIImage.init(named: "alertSymbol", in: .module, compatibleWith: nil)
        case .blik:
            return UIImage.init(named: "walletSymbol", in: .module, compatibleWith: nil)
        case .transaction:
            return UIImage.init(named: "walletSymbol", in: .module, compatibleWith: nil)
        }
    }
}

struct NotificationsInboxListCellViewModel {
    var title: String = ""
    var sendTime: String
    let enabledPushCategorie: EnabledPushCategorie
    let status: NotificationStatus
    
    var isUnreadedMessage: Bool {
        status == .delivered
    }
    
    var iconImage: UIImage? {
        switch enabledPushCategorie {
        case .notice:
            return UIImage(named: "announcementSymbol", in: .module, compatibleWith: nil)
        case .alert:
            return UIImage.init(named: "alertSymbol", in: .module, compatibleWith: nil)
        case .sales:
            return UIImage.init(named: "walletSymbol", in: .module, compatibleWith: nil)
        case .mail:
            return UIImage.init(named: "letterSymbol", in: .module, compatibleWith: nil)
        case .other:
            return UIImage.init(named: "flagSymbol", in: .module, compatibleWith: nil)
        }
    }
}
