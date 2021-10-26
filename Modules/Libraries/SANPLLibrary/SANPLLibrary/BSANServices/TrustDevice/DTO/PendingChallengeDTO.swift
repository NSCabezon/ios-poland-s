//
//  PendingChallengeDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 5/10/21.
//

import Foundation

public struct PendingChallengeDTO: Codable {
    public let authorizationId: Int?
    public let description: String?
    public let challenge: String
    public let expirationTime: String
    public let pendingChallengeOrigin: String
    public let softwareTokenKeys: [SoftwareTokenKeysDataDTO]
}

public struct SoftwareTokenKeysDataDTO: Codable {
    public let randomKey: String
    public let name: String
    public let softwareTokenType: String
}
