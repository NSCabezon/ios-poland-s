//
//  EncryptTextUseCaseProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 17/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol EncryptTextUseCaseProtocol {
    func encrypt(text: String, using pubKey: PubKey) throws -> String
}
