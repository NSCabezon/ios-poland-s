//
//  PLDomesticTransactionParametersType.swift
//  SANPLLibrary
//
//  Created by 187830 on 05/11/2021.
//

public enum PLDomesticTransactionParametersType {
    case transferToAnyAccount(PLDomesticTransactionParametersInput)
    case blikP2P(PLDomesticTransactionParametersInput)
    case splitPaymentToAnyAccount(PLDomesticTransactionParametersInput)
    case multiCurrencyTransfer(PLDomesticTransactionParametersInput)
    case foreignTransfer(PLDomesticTransactionParametersInput)
    case blikP2PR(PLDomesticTransactionParametersInput)
    case mCommerceBelow(PLDomesticTransactionParametersInput)
    case mCommerceUnder(PLDomesticTransactionParametersInput)
    case charityTransfer(PLDomesticTransactionParametersInput)
    case zusTransfer(PLDomesticTransactionParametersInput)
    case topUpTransfer(PLDomesticTransactionParametersInput)
}
