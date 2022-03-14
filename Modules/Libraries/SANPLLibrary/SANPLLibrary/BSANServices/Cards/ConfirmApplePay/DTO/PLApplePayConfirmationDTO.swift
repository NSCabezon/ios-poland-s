//
//  PLApplePayConfirmationDTO.swift
//  SANPLLibrary
//
//  Created by 188454 on 22/02/2022.
//

import Foundation

public struct PLApplePayConfirmationDTO: Codable {
    public let tav: String
    public let encryptedPassData: String
    public let ephemeralPublicKey: String
    
    public init(tav: String, encryptedPassData: String, ephemeralPublicKey: String) {
        self.tav = tav
        self.encryptedPassData = encryptedPassData
        self.ephemeralPublicKey = ephemeralPublicKey
    }
}
