//
//  CheckTransactionDTO.swift
//  SANPLLibrary
//
//  Created by Adrian Arcalá Ocón on 8/10/21.
//

import Foundation
import CoreDomain
import SANLegacyLibrary

public struct CheckTransactionDTO: Codable {
    let timestamp: String?
    let expressElixirStatus: Status?
    let blueCashStatus: Status?
}

struct Status: Codable {
    let code: String?
    let description: String?
}

extension CheckTransactionDTO: CheckTransactionAvailabilityRepresentable {
    public var expressElixirStatusCode: Int? {
        guard let status = self.expressElixirStatus,
              let code = status.code else { return nil }
        return Int(code)
    }
    
    public var blueCashStatusCode: Int? {
        guard let status = self.blueCashStatus,
              let code = status.code else { return nil }
        return Int(code)
    }
}
