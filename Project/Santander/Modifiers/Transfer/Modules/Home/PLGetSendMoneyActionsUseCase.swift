//
//  PLGetSendMoneyActionsUseCase.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 24/12/21.
//

import OpenCombine
import CoreDomain
import Models
import Commons
import Transfer

enum PTSendMoneyActionTypeIdentifier: String {
    case blik
    case anotherBank
    case creditCard
    case transferTax
    case transferZus
    case fxExchange
    case scanPay
    case topUpPhone
}

struct PLGetSendMoneyActionsUseCase {
    private let blik: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.blik.rawValue,
        title: "pl_transferOption_button_blik",
        description: "pl_transferOption_text_blik",
        icon: "oneIcnBlik"
    )
    
    private let anotherBank: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.anotherBank.rawValue,
        title: "pl_transferOption_button_transferAnotherBank",
        description: "pt_transferOption_text_transferPackages",
        icon: "icnTransferPackages"
    )
    
    private let creditCard: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.creditCard.rawValue,
        title: "pl_transferOption_button_creditCard",
        description: "pl_transferOption_text_creditCard",
        icon: "oneIcnCardRepayment"
    )
    
    private let creditCard: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.creditCard.rawValue,
        title: "pl_transferOption_button_creditCard",
        description: "pl_transferOption_text_creditCard",
        icon: "oneIcnCardRepayment"
    )
    
    private let transferTax: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.transferTax.rawValue,
        title: "pl_transferOption_button_transferTax",
        description: "pl_transferOption_text_transferTax",
        icon: "oneIcnTransferTax"
    )
    
    private let transferZus: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.transferZus.rawValue,
        title: "pl_transferOption_button_transferZus",
        description: "pl_transferOption_text_transferZus",
        icon: "oneIcnTransferZus"
    )
    
    private let transferZus: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.transferZus.rawValue,
        title: "pl_transferOption_button_transferZus",
        description: "pl_transferOption_text_transferZus",
        icon: "oneIcnTransferZus"
    )
    
    private let fxExchange: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.fxExchange.rawValue,
        title: "pl_transferOption_button_FxExchange",
        description: "pl_transferOption_text_FxExchange",
        icon: "oneIcnFxExchange"
    )
    
    private let scanPay: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.scanPay.rawValue,
        title: "pl_transferOption_button_ScanPay",
        description: "pl_transferOption_text_ScanPay",
        icon: "oneIcnScanPay"
    )
    
    private let topUpPhone: SendMoneyActionType = .custome(
        identifier: PTSendMoneyActionTypeIdentifier.topUpPhone.rawValue,
        title: "pl_transferOption_button_topUpPhone",
        description: "pl_transferOption_text_topUpPhone",
        icon: "oneIcnMobileTopUp"
    )
}

extension PLGetSendMoneyActionsUseCase: GetSendMoneyActionsUseCase {
    func fetchSendMoneyActions() -> AnyPublisher<[SendMoneyActionType], Never> {
        return CurrentValueSubject<[SendMoneyActionType], Never>(getHomeSendMoneyActions())
            .eraseToAnyPublisher()
    }
}

private extension PLGetSendMoneyActionsUseCase {
    func getHomeSendMoneyActions() -> [SendMoneyActionType] {
        return [.transfer, blik, .transferBetweenAccounts, .scheduleTransfers, anotherBank, .donations, transferTax, transferZus, fxExchange, scanPay, topUpPhone]
    }
}

