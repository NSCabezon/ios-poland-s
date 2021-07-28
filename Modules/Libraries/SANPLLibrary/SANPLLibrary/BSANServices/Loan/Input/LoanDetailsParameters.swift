//
//  LoanDetailsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanDetailsParameters: Encodable {
    public let includeDetails: Bool
    public let includePermissions: Bool?
    public let includeFunctionalities: Bool

    public init(includeDetails: Bool, includePermissions: Bool?, includeFunctionalities: Bool) {
        self.includeDetails = includeDetails
        self.includePermissions = includePermissions
        self.includeFunctionalities = includeFunctionalities
    }
}
