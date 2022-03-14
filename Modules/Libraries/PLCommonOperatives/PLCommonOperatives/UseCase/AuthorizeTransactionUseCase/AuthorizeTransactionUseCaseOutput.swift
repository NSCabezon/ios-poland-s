//
//  AuthorizeTransactionUseCaseOutput.swift
//  PhoneTopUp
//
//  Created by 188216 on 28/02/2022.
//

import Foundation
import CoreDomain

public struct AuthorizeTransactionUseCaseOutput {
    public let pendingChallenge: ChallengeRepresentable
    public let authorizationId: Int
    
    public init(pendingChallenge: ChallengeRepresentable, authorizationId: Int) {
        self.pendingChallenge = pendingChallenge
        self.authorizationId = authorizationId
    }
}
