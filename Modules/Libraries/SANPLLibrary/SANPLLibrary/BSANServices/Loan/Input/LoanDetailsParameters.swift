//
//  LoanDetailsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanDetailsParameters: Encodable {
    public let includeDetails: Bool
    public let includePermissions: Bool
    public let includeFunctionalities: Bool
}
