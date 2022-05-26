//
//  TaxTransferModelMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 27/04/2022.
//

import PLCommons
import CoreFoundationLib

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
    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
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
        let title = TaxTransferTitleBuilder(
            taxPayer: taxPayer,
            taxPayerInfo: taxPayerInfo,
            taxAuthority: taxAuthority,
            obligationIdentifier: formData.obligationIdentifier,
            period: billingPeriod,
            selectedBillingYear: selectedBillingYear,
            selectedPeriodNumber: selectedPeriodNumber,
            dependenciesResolver: dependenciesResolver
        ).build()
        let recipientAccountNumber = getRecipientAccountNumber(from: taxAuthority)
        let recipientName = getRecipientName(from: taxAuthority)
        
        return TaxTransferModel(
            amount: formData.amount.stringToDecimal ?? 0,
            title: title,
            account: account,
            recipientName: recipientName,
            recipientAccountNumber: recipientAccountNumber,
            transactionType: .taxTransfer,
            taxSymbol: taxAuthority.selectedTaxSymbol,
            taxPayer: taxPayer,
            taxPayerInfo: taxPayerInfo,
            billingPeriodType: billingPeriod,
            billingYear: selectedBillingYear,
            billingPeriodNumber: selectedPeriodNumber,
            obligationIdentifier: formData.obligationIdentifier,
            date: formData.date,
            taxAuthority: taxAuthority
        )
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
    
    private func getRecipientName(from taxAuthority: SelectedTaxAuthority) -> String {
        let name: String

        switch taxAuthority {
        case let .predefinedTaxAuthority(selectedPredefinedTaxAuthorityData):
            name = selectedPredefinedTaxAuthorityData.taxAuthority.name
        case let .irpTaxAuthority(selectedIrpTaxAuthorityData):
            name = selectedIrpTaxAuthorityData.taxAuthorityName
        case let .usTaxAuthority(selectedUsTaxAuthorityData):
            name = selectedUsTaxAuthorityData.taxAuthorityAccount.accountName
        }
        return name
    }
}
