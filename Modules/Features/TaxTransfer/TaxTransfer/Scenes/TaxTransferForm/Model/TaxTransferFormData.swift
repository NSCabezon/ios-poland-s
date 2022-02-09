//
//  TaxTransferFormData.swift
//  TaxTransfer
//
//  Created by 185167 on 19/01/2022.
//

import PLCommons

struct TaxTransferFormData {
    let sourceAccounts: [AccountForDebit]
    let taxPayers: [TaxPayer]
}
