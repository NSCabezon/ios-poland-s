//
//  BlikChallengesHandlerDelegate.swift
//  BLIK
//
//  Created by 187830 on 12/04/2022.
//

import CoreFoundationLib
import CoreDomain

public protocol BlikChallengesHandlerDelegate {
    func handle(
        _ challenge: ChallengeRepresentable,
        authorizationId: String,
        progressTotalTime: Float?,
        completion: @escaping (ChallengeResult) -> Void
    )
}
