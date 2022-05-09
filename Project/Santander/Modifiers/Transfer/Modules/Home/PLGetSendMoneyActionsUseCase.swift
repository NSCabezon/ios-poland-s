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

enum PLSendMoneyHomeActionTypeIdentifier: String {
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
    
    private let blik: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.blik.rawValue,
        title: "pl_transferOption_button_blik",
        description: "pl_transferOption_text_blik",
        icon: "oneIcnBlik"
    )
    
    private let anotherBank: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.anotherBank.rawValue,
        title: "pl_transferOption_button_transferAnotherBank",
        description: "pl_transferOption_text_transferAnotherBank",
        icon: "oneIcnAnotherBank"
    )
    
    private let creditCard: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.creditCard.rawValue,
        title: "pl_transferOption_button_creditCard",
        description: "pl_transferOption_text_creditCard",
        icon: "oneIcnCardRepayment"
    )
    
    private let transferTax: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.transferTax.rawValue,
        title: "pl_transferOption_button_transferTax",
        description: "pl_transferOption_text_transferTax",
        icon: "oneIcnTransferTax"
    )
    
    private let transferZus: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.transferZus.rawValue,
        title: "pl_transferOption_button_transferZus",
        description: "pl_transferOption_text_transferZus",
        icon: "oneIcnTransferZus"
    )
    
    private let fxExchange: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.fxExchange.rawValue,
        title: "pl_transferOption_button_FxExchange",
        description: "pl_transferOption_text_FxExchange",
        icon: "oneIcnFxExchange"
    )
    
    private let scanPay: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.scanPay.rawValue,
        title: "pl_transferOption_button_ScanPay",
        description: "pl_transferOption_text_ScanPay",
        icon: "oneIcnScanPay"
    )
    
    private let topUpPhone: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.topUpPhone.rawValue,
        title: "pl_transferOption_button_topUpPhone",
        description: "pl_transferOption_text_topUpPhone",
        icon: "oneIcnMobileTopUp"
    )
}

extension PLGetSendMoneyActionsUseCase: GetSendMoneyActionsUseCase {
    func fetchSendMoneyAction(_ location: PullOfferLocation) -> AnyPublisher<SendMoneyHomeActionType?, Never> {
        offersPublisher(location)
            .map { offer -> SendMoneyHomeActionType? in
                switch location.stringTag {
                case TransferPullOffers.donationTransferOffer:
                    return SendMoneyHomeActionType.donations(offer)
                default: return nil
                }
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    public func fetchSendMoneyActions(_ locations: [PullOfferLocation], page: String?) -> AnyPublisher<[SendMoneyHomeActionType], Never> {
        let actions = locations.map(fetchSendMoneyAction)
        return Publishers.MergeMany(actions)
            .collect()
            .map { offerActions in
                offerActions.compactMap({ $0 })
            }
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
    func getHomeSendMoneyActions(_ offerActions: [SendMoneyHomeActionType]) -> [SendMoneyHomeActionType] {
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
