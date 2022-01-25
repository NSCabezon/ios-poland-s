//
//  TaxTransferFormViewModel.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

struct TaxTransferFormViewModel {
    let account: Selectable<AccountViewModel>
    let taxPayer: Selectable<TaxPayerViewModel>
    let taxAuthority: Selectable<TaxAuthorityViewModel>
    let sendAmount: AmountViewModel
    let obligationIdentifier: String
}

extension TaxTransferFormViewModel {
    struct AccountViewModel {
        let id: String
        let accountName: String
        let maskedAccountNumber: String
        let unformattedAccountNumber: String
        let accountBalance: String
        let isEditButtonEnabled: Bool
    }
    
    struct TaxPayerViewModel {
        // TODO:- Add TaxPayerViewModel as associated value in TAP-2492
    }
    
    struct TaxAuthorityViewModel {
        // TODO: Add TaxAuthorityViewModel as associated value in TAP-2517
    }
    
    struct AmountViewModel {
        let amount: String
        let currency: String
    }
}
