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
        enum TaxPayerSecondaryIdentifier {
            case available(id: String)
            case notAvailable
        }
        
        let taxPayer: TaxPayer
        let taxPayerSecondaryIdentifier: TaxPayerSecondaryIdentifier
        let selectedInfo: SelectedTaxPayerInfo
        
        var hasDifferentTaxIdentifiers: Bool {
            guard let identifier = taxPayer.taxIdentifier else {
                return false
            }
            return identifier != taxPayer.secondaryTaxIdentifierNumber
        }
    }
    
    struct TaxAuthorityViewModel {
        let taxAuthorityName: String
        let taxFormSymbol: String
        let destinationAccountNumber: String
    }
    
    struct AmountViewModel {
        let amount: String
        let currency: String
    }
}
