//
//  TaxTransferAccountViewModelMapper.swift
//  TaxTransfer
//
//  Created by 185167 on 12/01/2022.
//

import PLCommons

protocol TaxTransferAccountViewModelMapping {
    func map(_ accounts: AccountForDebit, isEditButtonEnabled: Bool) -> TaxTransferFormViewModel.AccountViewModel
}

final class TaxTransferAccountViewModelMapper: TaxTransferAccountViewModelMapping {
    private let amountFormatter: NumberFormatter
    
    public init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(_ account: AccountForDebit, isEditButtonEnabled: Bool) -> TaxTransferFormViewModel.AccountViewModel {
        amountFormatter.currencySymbol = account.availableFunds.currency
        let accountBalance = amountFormatter.string(for: account.availableFunds.amount)
            ?? "\(account.availableFunds.amount) \(account.availableFunds.currency)"
        return TaxTransferFormViewModel.AccountViewModel(
            id: account.id,
            accountName: account.name,
            maskedAccountNumber: formatAccountNumber(account.number),
            unformattedAccountNumber: account.number,
            accountBalance: accountBalance,
            isEditButtonEnabled: isEditButtonEnabled
        )
    }
}

private extension TaxTransferAccountViewModelMapper {
    private func formatAccountNumber(_ accountNumber: String) -> String {
        let last4Digits = accountNumber.substring(ofLast: 4) ?? ""
        return "*" + last4Digits
    }
}
