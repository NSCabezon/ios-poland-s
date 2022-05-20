//
//  TaxTransferModelMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 27/04/2022.
//

import PLCommons

protocol TaxTransferModelMapping {
    func map(
        account: AccountForDebit,
        formData: TaxTransferFormFields,
        taxAuthority: SelectedTaxAuthority,
        taxPayer: TaxPayer,
        taxPayerInfo: SelectedTaxPayerInfo,
        billingPeriod: TaxTransferBillingPeriodType?,
        selectedBillingYear: String?,
        selectedPeriodNumber: Int?
    ) -> TaxTransferModel
}

final class TaxTransferModelMapper: TaxTransferModelMapping {
    private struct Constants {
        static var firstArg = "/TI/"
        static var secondArg = "/OKR/"
        static var thirdArg = "/SFP/"
        
        static var firstArgMaxLenght = 15
        static var secondArgMaxLenght = 7
        static var thirdArgMaxLength = 6
    }

    func map(
        account: AccountForDebit,
        formData: TaxTransferFormFields,
        taxAuthority: SelectedTaxAuthority,
        taxPayer: TaxPayer,
        taxPayerInfo: SelectedTaxPayerInfo,
        billingPeriod: TaxTransferBillingPeriodType?,
        selectedBillingYear: String?,
        selectedPeriodNumber: Int?
    ) -> TaxTransferModel {
        let title = getTitle(
            formData: formData,
            taxAuthority: taxAuthority,
            period: billingPeriod,
            selectedBillingYear: selectedBillingYear,
            selectedPeriodNumber: selectedPeriodNumber
        )
        let recipientAccountNumber = getRecipientAccountNumber(from: taxAuthority)
        
        return TaxTransferModel(
            amount: formData.amount.stringToDecimal ?? 0,
            title: title,
            account: account,
            recipientName: taxAuthority.selectedPredefinedTaxAuthority?.name,
            recipientAccountNumber: recipientAccountNumber,
            transactionType: .taxTransfer,
            taxSymbol: taxAuthority.selectedTaxSymbol,
            taxPayer: taxPayer,
            taxPayerInfo: taxPayerInfo,
            billingPeriodType: billingPeriod,
            billingYear: selectedBillingYear,
            billingPeriodNumber: selectedPeriodNumber,
            obligationIdentifier: formData.obligationIdentifier,
            date: formData.date
        )
    }

    private func getTitle(
        formData: TaxTransferFormFields,
        taxAuthority: SelectedTaxAuthority,
        period: TaxTransferBillingPeriodType?,
        selectedBillingYear: String?,
        selectedPeriodNumber: Int?
    ) -> String {
        let obligationIdentifier = formData.obligationIdentifier
        let taxAuthority = taxAuthority.selectedTaxSymbol.name
        let formattedYear = selectedBillingYear?.suffix(2) ?? ""
        let billingPeriod: String
        
        switch period {
        case .year:
            billingPeriod = "\(formattedYear)\(period?.short)"
        default:
            billingPeriod = "\(formattedYear)\(period?.short)\(selectedPeriodNumber ?? 0)"
        }

        guard obligationIdentifier.count <= Constants.firstArgMaxLenght,
              billingPeriod.count <= Constants.secondArgMaxLenght,
              taxAuthority.count <= Constants.thirdArgMaxLength else {
                  return ""
              }
        
        return Constants.firstArg + obligationIdentifier +
            Constants.secondArg + billingPeriod +
            Constants.thirdArg + taxAuthority
    }
    
    private func getRecipientAccountNumber(from taxAuthority: SelectedTaxAuthority) -> String {
        let accountNumber: String

        switch taxAuthority {
        case let .predefinedTaxAuthority(selectedPredefinedTaxAuthorityData):
            accountNumber = selectedPredefinedTaxAuthorityData.taxAuthority.accountNumber
        case let .irpTaxAuthority(selectedIrpTaxAuthorityData):
            accountNumber = selectedIrpTaxAuthorityData.accountNumber
        case let .usTaxAuthority(selectedUsTaxAuthorityData):
            accountNumber = selectedUsTaxAuthorityData.taxAuthorityAccount.accountNumber
        }
        return accountNumber
    }
}
