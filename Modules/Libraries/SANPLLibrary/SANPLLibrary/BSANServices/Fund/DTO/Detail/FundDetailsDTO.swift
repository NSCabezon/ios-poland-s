//
//  FundDetailsDTO.swift
//  SANPLLibrary
//
//  Created by Alberto Talavan Bustos on 25/2/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib


public struct FundDetailsDTO: Codable {
    public let number: String?
    public let id: Int?
    public let valuationDate: String?
    public let unitCategory: String?
    public let units: String?
    public let amount: BalanceDTO?
    public let amountPln: BalanceDTO?
    public let amountPerUnit: BalanceDTO?
    public let amountPerUnitPln: BalanceDTO?
}

extension FundDetailsDTO: FundDetailRepresentable {

    public var dateOfValuationRepresentable: Date? {
        Date().parse(valuationDate ?? "", format: .YYYYMMDD)
    }

    public var numberOfunitsRepresentable: String? {
        units
    }

    public var valueOfAUnitAmountRepresentable: AmountRepresentable? {
        amountPerUnit?.adaptBalanceToAmount()
    }

    public var totalValueAmountRepresentable: AmountRepresentable? {
        amount?.adaptBalanceToAmount()
    }

    public var categoryRepresentable: String? {
        unitCategory
    }
}
