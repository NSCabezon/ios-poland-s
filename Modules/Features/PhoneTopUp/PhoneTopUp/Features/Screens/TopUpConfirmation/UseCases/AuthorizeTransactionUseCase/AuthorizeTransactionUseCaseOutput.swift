//
//  AuthorizeTransactionUseCaseOutput.swift
//  PhoneTopUp
//
//  Created by 188216 on 28/02/2022.
//

import Foundation
import CoreDomain

struct AuthorizeTransactionUseCaseOutput {
    let pendingChallenge: ChallengeRepresentable
    let authorizationId: Int
}
