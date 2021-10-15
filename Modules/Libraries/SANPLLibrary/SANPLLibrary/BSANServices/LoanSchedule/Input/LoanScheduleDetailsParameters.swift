//
//  LoanDetailsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanScheduleParameters: Encodable {
    public let accountNumber: String

    public init(accountNumber: String) {
        self.accountNumber = accountNumber
    }
}
