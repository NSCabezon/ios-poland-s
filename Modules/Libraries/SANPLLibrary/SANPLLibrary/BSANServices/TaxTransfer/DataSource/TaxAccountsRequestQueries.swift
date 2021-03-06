//
//  TaxAccountsRequestQueries.swift
//  SANPLLibrary
//
//  Created by 185167 on 15/03/2022.
//

public struct TaxAccountsRequestQueries {
    public let accountNumber: String?
    public let accountName: String?
    public let city: String?
    public let optionId: Int?
    
    public init(
        accountNumber: String? = nil,
        accountName: String? = nil,
        city: String? = nil,
        optionId: Int? = nil
    ) {
        self.accountNumber = accountNumber
        self.accountName = accountName
        self.city = city
        self.optionId = optionId
    }
}
