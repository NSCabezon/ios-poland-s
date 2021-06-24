//
//  LoanDetailsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct LoanDetailsParameters: Encodable {
    public let includeDetails: String
    public let includePermissions: String?
    public let includeFunctionalities: String

    public init(includeDetails: Bool, includePermissions: Bool?, includeFunctionalities: Bool) {
        self.includeDetails = includeDetails ? "true" : "false"
        if let value = includePermissions {
            self.includePermissions = value ? "true" : "false"
        } else {
            self.includePermissions = nil
        }
        self.includeFunctionalities = includeFunctionalities  ? "true" : "false"
    }
}
