//
//  BlikChallengeDTO.swift
//  BLIK
//
//  Created by 187830 on 26/04/2022.
//

import CoreDomain

public struct BlikChallengeDTO: Codable {
    public let challenge: String
}

extension BlikChallengeDTO: SendMoneyChallengeRepresentable {
    public var challengeRepresentable: String? { challenge }
}
