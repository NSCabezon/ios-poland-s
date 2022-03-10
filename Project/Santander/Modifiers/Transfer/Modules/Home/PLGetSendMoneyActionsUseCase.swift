//
//  PLGetSendMoneyActionsUseCase.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 24/12/21.
//

import OpenCombine
import CoreDomain
import Transfer
import CoreFoundationLib

enum PLSendMoneyActionTypeIdentifier: String {
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
    var candidateOfferUseCase: GetCandidateOfferUseCase
    public init(candidateOfferUseCase: GetCandidateOfferUseCase) {
        self.candidateOfferUseCase = candidateOfferUseCase
    }
    
    private let blik: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.blik.rawValue,
        title: "pl_transferOption_button_blik",
        description: "pl_transferOption_text_blik",
        icon: "oneIcnBlik"
    )
    
    private let anotherBank: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.anotherBank.rawValue,
        title: "pl_transferOption_button_transferAnotherBank",
        description: "pt_transferOption_text_transferPackages",
        icon: "oneIcnAnotherBank"
    )
    
    private let creditCard: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.creditCard.rawValue,
        title: "pl_transferOption_button_creditCard",
        description: "pl_transferOption_text_creditCard",
        icon: "oneIcnCardRepayment"
    )
    
    private let transferTax: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.transferTax.rawValue,
        title: "pl_transferOption_button_transferTax",
        description: "pl_transferOption_text_transferTax",
        icon: "oneIcnTransferTax"
    )
    
    private let transferZus: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.transferZus.rawValue,
        title: "pl_transferOption_button_transferZus",
        description: "pl_transferOption_text_transferZus",
        icon: "oneIcnTransferZus"
    )
    
    private let fxExchange: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.fxExchange.rawValue,
        title: "pl_transferOption_button_FxExchange",
        description: "pl_transferOption_text_FxExchange",
        icon: "oneIcnFxExchange"
    )
    
    private let scanPay: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.scanPay.rawValue,
        title: "pl_transferOption_button_ScanPay",
        description: "pl_transferOption_text_ScanPay",
        icon: "oneIcnScanPay"
    )
    
    private let topUpPhone: SendMoneyActionType = .custome(
        identifier: PLSendMoneyActionTypeIdentifier.topUpPhone.rawValue,
        title: "pl_transferOption_button_topUpPhone",
        description: "pl_transferOption_text_topUpPhone",
        icon: "oneIcnMobileTopUp"
    )
}

extension PLGetSendMoneyActionsUseCase: GetSendMoneyActionsUseCase {
    func fetchSendMoneyAction(_ location: PullOfferLocation) -> AnyPublisher<SendMoneyActionType, Error> {
        offersPublisher(location)
            .compactMap { offer -> SendMoneyActionType? in
                switch location.stringTag {
                case TransferPullOffers.fxpayTransferHomeOffer:
                    return SendMoneyActionType.onePayFX(offer)
                case TransferPullOffers.donationTransferOffer:
                    return SendMoneyActionType.donations(offer)
                case TransferPullOffers.correosCashOffer:
                    return SendMoneyActionType.correosCash(offer)
                default: return nil
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchSendMoneyActions(_ locations: [PullOfferLocation]) -> AnyPublisher<[SendMoneyActionType], Never> {
        let actions = locations.map(fetchSendMoneyAction)
        return Publishers.MergeMany(actions)
            .collect()
            .replaceError(with: [])
            .map(getHomeSendMoneyActions)
            .eraseToAnyPublisher()
    }
    
    func offersPublisher(_ location: PullOfferLocationRepresentable) -> AnyPublisher<OfferRepresentable, Error> {
        return candidateOfferUseCase
            .fetchCandidateOfferPublisher(location: location)
            .receive(on: Schedulers.main)
            .eraseToAnyPublisher()
    }
}

private extension PLGetSendMoneyActionsUseCase {
    func getHomeSendMoneyActions(_ offerActions: [SendMoneyActionType]) -> [SendMoneyActionType] {
        var actions = [.transfer, blik, .transferBetweenAccounts, .scheduleTransfers, anotherBank, creditCard, transferTax, transferZus, fxExchange, scanPay, topUpPhone]
        for action in offerActions {
            switch action {
            case .donations:
                actions.insert(action, at: 5)
            default: break
            }
        }
        return actions
    }
}
