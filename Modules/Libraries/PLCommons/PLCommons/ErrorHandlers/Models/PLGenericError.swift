//
//  PLGenericError.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import CoreFoundationLib

public enum PLGenericError: Equatable {
    
    case noConnection
    case unknown
    case other(_ errorTypeDescription: String)
    case applicationNotWorking
    case maintenance
    case unauthorized
    
    public var rawValue: String {
        return "generic_\(self)"
    }
    
    func getErrorDesc() -> String {
        switch self {
        case .noConnection:
            return localized("pl_login_alert_applicationNotWorking")
        case .unknown:
            return localized("generic_error_txt")
        case .other(_):
            return localized("generic_error_txt")
        case .applicationNotWorking:
            return localized("pl_onboarding_alert_genFailedText")
        case .unauthorized:
            return localized("pl_login_alert_loginError")
        case .maintenance:
            return localized("generic_error_txt")
        }
    }
}
