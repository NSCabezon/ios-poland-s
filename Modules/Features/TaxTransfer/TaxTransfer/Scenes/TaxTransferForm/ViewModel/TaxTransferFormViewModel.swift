//
//  TaxTransferFormViewModel.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

struct TaxTransferFormViewModel {
    let selectedAccount: SelectedAccount
    let taxPayer: TaxPayer
    let taxAuthority: TaxAuthority
    let sendAmount: Amount
    let obligationIdentifier: String
    let transferDate: TransferDate
}

extension TaxTransferFormViewModel {
    struct SelectedAccount {
        let accountName: String
        let maskedAccountNumber: String
        let unformattedAccountNumber: String
        let accountBalance: String
        let isOnlyAccount: Bool
    }
    
    enum TaxPayer {
        case selected // TODO:- Add TaxPayerViewModel as associated value
        case unselected
    }
    
    enum TaxAuthority {
        case selected // TODO: Add TaxAuthorityViewModel as associated value
        case unselected
    }
    
    struct Amount {
        let amount: String
        let currency: String
    }
    
    enum TransferDate {
        case today
        case otherDay(Date)
    }
}
