//
//  LoginDTO.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public struct LoginDTO: Codable {
    public let userId: Int
    public let passwordMask: Int?
    public let loginImageData: String?
    public let passwordMaskEnabled: Bool?
    public let secondFactorData: SecondFactorDataDTO
    public let trustedComputerData: TrustedComputerDataDTO?
}

public struct SecondFactorDataDTO: Codable {
    public let finalState: String
    public let challenges: [ChallengeDTO]?
    public let defaultChallenge: ChallengeDTO
    public let expired: Bool?
    public let unblockRemainingTimeInSecs: Double?
}

public struct ChallengeDTO: Codable {
    public let authorizationType, value: String
}

public struct TrustedComputerDataDTO: Codable {
    public let state: String?
    public let register: Bool?
}
