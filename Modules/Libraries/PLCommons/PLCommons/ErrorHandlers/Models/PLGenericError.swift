//
//  PLGenericError.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import Commons

public enum PLGenericError {
    
    case noConnection
    case unknown
    case applicationNotWorking
    case unauthorized
    
    public var rawValue: String {
        return "generic_\(self)"
    }
    
    func getErrorDesc() -> String {
        switch self {
        case .noConnection:
            return localized("generic_error_internetConnection")
        case .unknown:
            return localized("generic_error_txt")
        case .applicationNotWorking:
            return localized("pl_login_alert_applicationNotWorking")
        case .unauthorized:
            return localized("pl_login_alert_loginError")
        }
    }
}
