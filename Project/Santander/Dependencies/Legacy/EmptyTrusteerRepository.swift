//
//  EmptyTrusteerRepository.swift
//  Santander
//
//  Created by Jose C. Yebes on 4/05/2021.
//

import Foundation
import CoreFoundationLib

final class EmptyTrusteerRepository {
    let appSessionId: String? = nil
}

extension EmptyTrusteerRepository: TrusteerRepositoryProtocol {
    func notifyLoginFlow(appSessionId: String, appPUID: String) {}
    func destroySession() {}
    func initialize() {}
}
