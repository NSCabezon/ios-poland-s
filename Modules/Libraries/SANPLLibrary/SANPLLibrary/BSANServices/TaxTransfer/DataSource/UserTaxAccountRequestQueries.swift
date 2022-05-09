//
//  UserTaxAccountRequestQueries.swift
//  SANPLLibrary
//
//  Created by 185167 on 12/04/2022.
//

public struct UserTaxAccountRequestQueries: Codable, Equatable {
    public let accountNumber: String
    public let systemId: Int
    
    public init(accountNumber: String, systemId: Int) {
        self.accountNumber = accountNumber
        self.systemId = systemId
    }
}
