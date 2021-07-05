//
//  AccountDetailsParameters.swift
//  SANPLLibrary
//

import Foundation

public struct AccountDetailsParameters: Encodable {
    public let includeDetails: String
    public let includePermissions: String

    public init(includeDetails: Bool, includePermissions: Bool) {
        self.includeDetails = includeDetails.description
        self.includePermissions = includePermissions.description
    }
}
