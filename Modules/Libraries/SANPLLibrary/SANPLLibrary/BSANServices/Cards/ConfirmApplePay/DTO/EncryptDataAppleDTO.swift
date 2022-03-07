//
//  EncryptDataAppleDTO.swift
//  Account
//
//  Created by 188454 on 18/02/2022.
//

import Foundation

public struct EncryptDataAppleDTO: Codable {
    public let nonce: String
    public let nonceSignature: String
    
    public init(nonce: String, nonceSignature: String) {
        self.nonce = nonce
        self.nonceSignature = nonceSignature
    }
}
