//
//  AccessType.swift
//  PLCommons
//
//  Created by Cristobal Ramos Laina on 17/11/21.
//

public enum AccessType: Equatable {
    case pin (value: String)
    case biometrics
    
    public func getString() -> String{
        switch self {
        case .pin(value: _): return "PIN"
        case .biometrics: return "BIOMETRICS"
        }
    }
}
