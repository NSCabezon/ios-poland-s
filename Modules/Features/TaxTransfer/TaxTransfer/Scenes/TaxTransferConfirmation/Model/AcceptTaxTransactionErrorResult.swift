//
//  AcceptTaxTransactionErrorResult.swift
//  TaxTransfer
//
//  Created by 187831 on 06/04/2022.
//

enum AcceptTaxTransactionErrorResult: String {
    case noConnection
    case limitExceeded
    case generalErrorMessages
    case accountOnBlacklist
    case expressRecipientInactive
}
