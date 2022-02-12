//
//  PhoneTransferRegistrationFormViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 16/08/2021.
//

import PLCommons
import CoreFoundationLib

protocol PhoneTransferRegistrationFormViewModelMapping {
    func map(_ account: BlikCustomerAccount) -> PhoneTransferRegistrationFormViewModel
}

final class PhoneTransferRegistrationFormViewModelMapper: PhoneTransferRegistrationFormViewModelMapping {
    private let amountFormatter: NumberFormatter
    
    init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(_ account: BlikCustomerAccount) -> PhoneTransferRegistrationFormViewModel {
        amountFormatter.currencySymbol = account.availableFunds.currency
        return getViewModel(
            accountNumber: account.number,
            accountName: account.name,
            availableFunds: getAvailableFundsText(
                forAmount: account.availableFunds.amount,
                currency: account.availableFunds.currency
            )
        )
    }
    
    private func getViewModel(
        accountNumber: String,
        accountName: String,
        availableFunds: String
    ) -> PhoneTransferRegistrationFormViewModel {
        let hintMessage: String = localized("pl_blik_text_registerNumbDesc")
        let accountViewTitle: String = localized("pl_blik_text_numbAccountRegist")
        
        let phoneViewTitle: String = localized("pl_blik_text_numbPhoneRegist")
        let phoneViewNumber: String = localized("pl_blik_text_numbSameAs")
        
        let statementTitle: String = localized("pl_blik_text_declarationRegist")
        let statementDescription: LocalizedStylableText = localized("pl_blik_text_declarationMeaning",
                                                                    [StringPlaceholder(.value, accountNumber)])
        
        return PhoneTransferRegistrationFormViewModel(
            hintMessage: hintMessage,
            accountViewModel: .init(
                title: accountViewTitle,
                accountName: accountName,
                availableFunds: availableFunds,
                accountNumber: accountNumber
            ),
            phoneViewModel: .init(
                title: phoneViewTitle,
                phoneNumber: phoneViewNumber
            ),
            statementViewModel: .init(
                title: statementTitle,
                description: statementDescription)
        )
    }
    
    private func getAvailableFundsText(
        forAmount amount: Decimal,
        currency: String
    ) -> String {
        return amountFormatter.string(for: amount) ?? "\(amount) \(currency)"
    }
}
