//
//  PendingChallengeDTO.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 5/10/21.
//

import Foundation
import CoreDomain

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

extension PendingChallengeDTO: PINChallengeRepresentable {}

extension PendingChallengeDTO: ChallengeRepresentable {
    public var identifier: String {
        return softwareTokenKeys.map{ $0.softwareTokenType }.joined(separator: "+")
    }
}
