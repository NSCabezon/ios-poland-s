//
//  MockChallengesHandlerDelegate.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CoreFoundationLib
import CoreDomain

final class MockChallengesHandlerDelegate: ChallengesHandlerDelegate {
    func handle(_ challenge: ChallengeRepresentable, authorizationId: String, completion: @escaping (ChallengeResult) -> Void) {
        completion(.notHandled)
    }
}
