//
//  EncryptedUserKeys.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 19/10/21.
//

public struct EncryptedUserKeys: Codable {
    public let pinUserKey: String
    public let biometricUserKey: String?

    public init(pinUserKey: String, biometricUserKey: String?) {
        self.pinUserKey = pinUserKey
        self.biometricUserKey = biometricUserKey
    }
}

