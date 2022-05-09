//
//  TaxTransferSummary.swift
//  TaxTransfer
//
//  Created by 187831 on 06/04/2022.
//

import SANLegacyLibrary
import SANPLLibrary

public struct TaxTransferSummary {
    let amount: Decimal
    let currency: CurrencyType
    let title: String
    let accountName: String
    let accountNumber: String
    let recipientName: String
    let recipientAccountNumber: String
    let dateString: String
    let transferType: AcceptDomesticTransactionParameters.TransferType?
}
