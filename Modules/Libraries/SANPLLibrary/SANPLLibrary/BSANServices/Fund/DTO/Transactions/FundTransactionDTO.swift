//
//  FundTransactionDTO.swift
//  SANPLLibrary
//
//  Created by Alberto Talavan Bustos on 25/2/22.
//

import CoreDomain
import CoreFoundationLib

public struct FundTransactionDTO: Codable {
    public let executionDate: String?
    public let submittedDate: String?
    public let operName: String?
    public let amount: BalanceDTO?
    public let amountPln: BalanceDTO?
    public let units: String?
}

extension FundTransactionDTO: FundMovementRepresentable {
    public var dateRepresentable: Date? {
        Date().parse(self.executionDate ?? "", format: TimeFormat.yyyyMMdd.rawValue)
    }

    public var submittedDateRepresentable: Date? {
        Date().parse(self.submittedDate ?? "", format: TimeFormat.yyyyMMdd.rawValue)
    }

    public var nameRepresentable: String? {
        self.operName
    }

    public var unitsRepresentable: String? {
        self.units
    }

    public var amountRepresentable: AmountRepresentable? {
        self.amount?.adaptBalanceToAmount()
    }
}

extension FundTransactionDTO: FundMovementDetailRepresentable {
    public var detailsRepresentable: [(title: String, value: String)]? {
        nil
    }
}
