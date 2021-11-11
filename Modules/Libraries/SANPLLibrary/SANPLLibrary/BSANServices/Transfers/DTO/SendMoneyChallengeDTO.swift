//
//  SendMoneyChallengeDTO.swift
//  SANPLLibrary
//
//  Created by Luis Escámez Sánchez on 4/11/21.
//

import Foundation
import CoreDomain

struct SendMoneyChallengeDTO: Codable {
    let challenge: String?
}

extension SendMoneyChallengeDTO: SendMoneyChallengeRepresentable {
    var challengeRepresentable: String? { challenge }
}
