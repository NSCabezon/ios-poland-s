//
//  PendingChallengeParameters.swift
//  SANPLLibrary
//
//  Created by Juan Sánchez Marín on 5/10/21.
//

import Foundation

public struct PendingChallengeParameters: Encodable {
    let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}
