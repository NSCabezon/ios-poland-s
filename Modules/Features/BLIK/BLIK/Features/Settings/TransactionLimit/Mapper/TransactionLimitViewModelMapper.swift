//
//  TransactionLimitViewModelMapper.swift
//  BLIK
//
//  Created by 186491 on 26/08/2021.
//

import Commons
import SANLegacyLibrary

protocol TransactionLimitViewModelMapping {
    func map(_ wallet: GetWalletUseCaseOkOutput.Wallet) -> TransactionLimitViewModel
    func mapAmount(_ amount: String) -> Decimal?
}

final class TransactionLimitViewModelMapper: TransactionLimitViewModelMapping {
    
    private let amountFormatterWithCurrency: NumberFormatter
    private let amountFormatterWithoutCurrency: NumberFormatter
    
    init(
        amountFormatterWithCurrency: NumberFormatter,
        amountFormatterWithoutCurrency: NumberFormatter
    ) {
        self.amountFormatterWithCurrency = amountFormatterWithCurrency
        self.amountFormatterWithoutCurrency = amountFormatterWithoutCurrency
    }
    
    func map(_ wallet: GetWalletUseCaseOkOutput.Wallet) -> TransactionLimitViewModel {
        
        let withdrawLimitText = localized(
            "pl_blik_text_limitMax",
            [StringPlaceholder(.value, getAmountText(forAmount: wallet.limits.cashLimitInfo.cycleLimitRemaining))]
        )
        let purchaseLimitText = localized(
            "pl_blik_text_limitMax",
            [StringPlaceholder(.value, getAmountText(forAmount: wallet.limits.shopLimitInfo.cycleLimitRemaining))]
        )
        
        let viewModel = TransactionLimitViewModel(
            withdrawLimitValue: getAmountText(forAmount: wallet.limits.cashLimitInfo.cycleLimit),
            purchaseLimitValue: getAmountText(forAmount: wallet.limits.shopLimitInfo.cycleLimit),
            limitCurrency: CurrencyType.złoty.name,
            chequqBlikLimitValue: getAmountText(forAmount: wallet.limits.cashLimitInfo.trnLimit, currency: CurrencyType.złoty.name),
            withdrawLimitText: withdrawLimitText.text,
            purchaseLimitText: purchaseLimitText.text
        )
        
        return viewModel
    }
    
    func mapAmount(_ amount: String) -> Decimal? {
        guard let amount = amountFormatterWithoutCurrency.number(from: amount) else {
            return nil
        }
        return Decimal(Double(truncating: amount))
    }
    
    private func getAmountText(
        forAmount amount: Decimal,
        currency: String
    ) -> String {
        amountFormatterWithCurrency.currencySymbol = currency
        return amountFormatterWithCurrency.string(for: amount) ?? "\(amount) \(currency)"
    }
    
    private func getAmountText(forAmount amount: Decimal) -> String {
        return amountFormatterWithoutCurrency.string(for: amount) ?? "\(amount)"
    }
}
