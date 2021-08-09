//
//  RegisterSoftwareTokenDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 22/6/21.
//

import Foundation

public struct RegisterSoftwareTokenDTO: Codable {
    public let tokens: [TokenDTO]
    public let trustedDeviceState: String
}

public struct TokenDTO: Codable {
    public let name, key, type, state: String
    public let id, timestamp: Int
}
