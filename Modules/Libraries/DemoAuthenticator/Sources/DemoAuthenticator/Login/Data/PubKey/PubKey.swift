//
//  PubKeyResult.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

struct PubKey: Decodable {
    let modulus: String
    let exponent: String
}
