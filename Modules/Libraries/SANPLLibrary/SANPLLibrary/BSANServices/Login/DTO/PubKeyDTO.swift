//
//  PubKeyDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 18/5/21.
//

import Foundation

public struct PubKeyDTO: Codable {
    public let modulus, exponent: String
}
