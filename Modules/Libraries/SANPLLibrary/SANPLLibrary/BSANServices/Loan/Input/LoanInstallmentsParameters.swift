//
//  LoanInstallmentsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanInstallmentsParameters: Encodable {
    public var pageSize: Int

    public init(pageSize: Int) {
        self.pageSize = pageSize
    }
}
