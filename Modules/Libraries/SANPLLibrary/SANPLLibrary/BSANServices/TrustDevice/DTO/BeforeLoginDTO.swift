//
//  BeforeLoginDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 28/9/21.
//

import Foundation

public enum SoftwareTokenType : String {
    case PIN = "PIN"
    case BIOMETRICS = "BIOMETRICS"
    case UNKNOWN = "unknown"
}

public struct BeforeLoginDTO: Codable {
    public let userId, pushCount: Int
    public let paymentAccountSequenceNumber: Int?
    public let certificateTime: String
    public let fingerprint: String?
    public let pinMobileDefault, pinMobileDisabled, awaitingBlikConfirmation: Bool
    public let integrator: IntegratorDTO?
    public let softwareTokenHeaders:[SoftwareTokenHeaderDTO]
    
    public func containsBiometrics() -> Bool {
        return softwareTokenHeaders.first { token in return token.typeMapped == .BIOMETRICS } != nil
    }
    
    public func containsPin() -> Bool {
        return softwareTokenHeaders.first { token in return token.typeMapped == .PIN } != nil
    }
}

public struct IntegratorDTO: Codable {
    public let name, encryptedPassword, state: String
}

public struct SoftwareTokenHeaderDTO: Codable {
    public let name, state, type : String
    public let awaitingSoftwareTokenConfirmation: Bool
    
    var typeMapped: SoftwareTokenType {
        switch self.type.uppercased() {
        case "PIN":
            return .PIN
        case "BIOMETRICS":
            return .BIOMETRICS
        default:
            return .UNKNOWN
        }
    }
}
