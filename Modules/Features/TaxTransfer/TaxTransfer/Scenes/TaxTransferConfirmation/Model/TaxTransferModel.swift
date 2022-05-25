//
//  TaxTransferModel.swift
//  TaxTransfer
//
//  Created by 187831 on 06/04/2022.
//

import PLUI
import PLCommons

public struct TaxTransferModel {
    public let amount: Decimal
    public let title: String?
    public let account: AccountForDebit
    public let recipientName: String?
    public let recipientAccountNumber: String
    public let transactionType: TransactionType
    public let taxSymbol: TaxSymbol
    public let taxPayer: TaxPayer
    public let taxPayerInfo: SelectedTaxPayerInfo
    public let billingPeriodType: TaxTransferBillingPeriodType?
    public let billingYear: String?
    public let billingPeriodNumber: Int?
    public let obligationIdentifier: String
    public let date: Date
    let taxAuthority: SelectedTaxAuthority
}

