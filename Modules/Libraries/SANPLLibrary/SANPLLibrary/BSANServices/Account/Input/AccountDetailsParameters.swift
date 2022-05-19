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

public struct WithholdingParameters: Encodable {
    public let accountNumbers: [String]

    public init(accountNumbers: [String]) {
        self.accountNumbers = accountNumbers
    }
}

public struct ChangeAliasParameters: Encodable {
    public let userDefined: String
    
    public init(userDefined: String) {
        self.userDefined = userDefined
    }
}

public struct SwiftBranchesParameters: Encodable {
    public let countryCode: String
    public let customerType: String
    public let currencyCode: String
    public let bic: String
    
    public init(countryCode: String,
                customerType: String = "PERSONAL",
                currencyCode: String,
                bicSwift: String) {
        self.countryCode = countryCode
        self.customerType = customerType
        self.currencyCode = currencyCode
        self.bic = bicSwift
    }
}
