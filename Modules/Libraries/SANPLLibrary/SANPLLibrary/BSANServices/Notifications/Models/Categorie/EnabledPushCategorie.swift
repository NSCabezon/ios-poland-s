//
//  EnabledPushCategorie.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 15/02/2022.
//

import CoreFoundationLib

public enum EnabledPushCategorie: String, CodingKey, Codable, CaseIterable {
    case alert = "ALERT"
    case notice = "NOTICE"
    case sales = "SALES"
    case mail = "MAIL"
    case other = "OTHER"
    
    public func getLabel() -> String{
        switch self {
        case .alert:
            return localized("pl_alerts_text_typeAlert")
        case .notice:
            return localized("pl_alerts_text_typeInform")
        case .sales:
            return localized("pl_alerts_text_typeSale")
        case .mail:
            return localized("pl_alerts_text_typeMail")
        case .other:
            return localized("pl_alerts_text_typeOther")
        }
    }
}

