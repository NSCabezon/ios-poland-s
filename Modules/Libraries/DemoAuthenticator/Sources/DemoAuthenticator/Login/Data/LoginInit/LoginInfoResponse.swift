//
//  LoginInfoResponse.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

struct LoginInfoResponse: Decodable {
    let userId: Int
    let passwordMaskEnabled: Bool
    let passwordMask: Int?
    let secondFactorData: LoginInfoResponse.SecondFactor
    let trustedComputerData: LoginInfoResponse.TrustedComputerData

    struct TrustedComputerData: Decodable {
        let state: LoginInfoResponse.TrustedComputerData.State
        let register: Bool

        enum State: String, Decodable {
            case notAllowed = "NOT_ALLOWED"
        }
    }

    struct SecondFactor: Codable {
        let finalState: SecondFactor.SecondFactorState
        let unblockAvailableIn: Int?
        let challenges: [Challenge]
        let defaultChallenge: Challenge
        let expired: Bool

        enum SecondFactorState: String, Codable {
            case notFinal = "NOT_FINAL"
            case final = "FINAL"
            case blocked = "BLOCKED"
        }
    }

}
