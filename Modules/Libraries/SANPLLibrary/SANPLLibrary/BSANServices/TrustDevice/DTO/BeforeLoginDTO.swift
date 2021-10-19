//
//  BeforeLoginDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 28/9/21.
//

import Foundation

public struct BeforeLoginDTO: Codable {
    public let userId, pushCount: Int
    public let paymentAccountSequenceNumber: Int?
    public let certificateTime: String
    public let fingerprint: String?
    public let pinMobileDefault, pinMobileDisabled, awaitingBlikConfirmation: Bool
    public let integrator: IntegratorDTO?
    public let softwareTokenHeaders:[SoftwareTokenHeaderDTO]
    
    public func containsBiometrics() -> Bool {
        return softwareTokenHeaders.first { token in return token.type == "BIOMETRICS" } != nil
    }
}

public struct IntegratorDTO: Codable {
    public let name, encryptedPassword, state: String
}

public struct SoftwareTokenHeaderDTO: Codable {
    public let name, state, type : String
    public let awaitingSoftwareTokenConfirmation: Bool
}
