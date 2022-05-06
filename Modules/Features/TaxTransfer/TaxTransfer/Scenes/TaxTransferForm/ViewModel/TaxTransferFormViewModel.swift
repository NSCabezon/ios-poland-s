//
//  TaxTransferFormViewModel.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import PLScenes
import SANPLLibrary

struct TaxTransferFormViewModel {
    let account: Selectable<AccountViewModel>
    let taxPayer: Selectable<TaxPayerViewModel>
    let taxAuthority: Selectable<TaxAuthorityViewModel>
    let billingPeriod: BillingPeriodVisibility
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
        let accountSequenceNumber: Int
        let accountType: Int
        let isEditButtonEnabled: Bool
    }
    
    struct TaxPayerViewModel: SelectableItem {
        enum TaxPayerSecondaryIdentifier {
            case available(id: String)
            case notAvailable
        }
        
        let taxPayer: TaxPayer
        let taxPayerSecondaryIdentifier: TaxPayerSecondaryIdentifier
        let selectedInfo: SelectedTaxPayerInfo?
        
        var identifier: String {
            return String(taxPayer.identifier)
        }

        var name: String {
            return taxPayer.name ?? ""
        }

        var hasDifferentTaxIdentifiers: Bool {
            guard let taxIdentifier = taxPayer.taxIdentifier, !taxIdentifier.isEmpty else {
                return false
            }
            return taxIdentifier != taxPayer.secondaryTaxIdentifierNumber
        }
        
        static func == (lhs: TaxTransferFormViewModel.TaxPayerViewModel, rhs: TaxTransferFormViewModel.TaxPayerViewModel) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.name == rhs.name
        }
    }
    
    struct TaxBillingPeriodViewModel: SelectableItem {
        let periodType: TaxTransferBillingPeriodType
        let year: String
        let periodNumber: Int?
        
        var identifier: String {
            return UUID().uuidString
        }

        var name: String {
            return periodType.name
        }
        
        static func == (lhs: TaxTransferFormViewModel.TaxBillingPeriodViewModel,
                        rhs: TaxTransferFormViewModel.TaxBillingPeriodViewModel) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.name == rhs.name
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
    
    enum BillingPeriodVisibility {
        case visible(Selectable<TaxBillingPeriodViewModel>)
        case hidden
    }
}
