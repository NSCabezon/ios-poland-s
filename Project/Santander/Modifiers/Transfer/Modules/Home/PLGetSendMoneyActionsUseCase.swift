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
import SANPLLibrary

protocol PLGetSendMoneyActionsUseCaseDependenciesResolver {
    func resolve() -> GetCandidateOfferUseCase
    func resolve() -> BSANDataProvider
}

enum PLSendMoneyHomeActionTypeIdentifier: String {
    case blik
    case anotherBank
    case creditCard
    case transferTax
    case transferZus
    case fxExchange
    case scanPay
    case topUpPhone
    case splitPayment
    case pendingSignatures
}

struct PLGetSendMoneyActionsUseCase {
    var candidateOfferUseCase: GetCandidateOfferUseCase
    var dataProvider: BSANDataProvider
    
    public init(dependencies: PLGetSendMoneyActionsUseCaseDependenciesResolver) {
        self.candidateOfferUseCase = dependencies.resolve()
        self.dataProvider = dependencies.resolve()
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
    
    private let splitPayment: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.splitPayment.rawValue,
        title: "pl_transferOption_button_splitPayment",
        description: "pl_transferOption_text_splitPayment",
        icon: "oneIcnSplit"
    )
    
    private let pendingSignatures: SendMoneyHomeActionType = .custom(
        identifier: PLSendMoneyHomeActionTypeIdentifier.pendingSignatures.rawValue,
        title: "pl_transferOption_button_pendingSignatures",
        description: "pl_transferOption_text_pendingSignatures",
        icon: "oneIcnPendingSignatures"
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
        guard let contexts = dataProvider.getCustomerIndividual()?.customerContexts,
           let selectedContext = contexts.filter({ $0.selected == true }).first,
           let contextType = selectedContext.type
        else {
           return getDefaultActions(offerActions)
        }
        return getActions(context: contextType, offerActions: offerActions)
    }
    
    func getActions(context: ContextType, offerActions: [SendMoneyHomeActionType]) -> [SendMoneyHomeActionType] {
        switch context {
        case .INDIVIDUAL:
            return getDefaultActions(offerActions)
        case .COMPANY:
            return getMojaFirmaActions()
        case .PROXY, .MINI_COMPANY:
            return getMiniFirmaActions(offerActions)
        }
    }
    
    func getDefaultActions(_ offerActions: [SendMoneyHomeActionType]) -> [SendMoneyHomeActionType] {
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
    
    func getMojaFirmaActions() -> [SendMoneyHomeActionType] {
        return [.transfer, splitPayment, transferTax, transferZus, pendingSignatures, fxExchange]
    }
    
    func getMiniFirmaActions(_ offerActions: [SendMoneyHomeActionType]) -> [SendMoneyHomeActionType] {
        var actions = [.transfer, splitPayment, blik, .transferBetweenAccounts, .scheduleTransfers, anotherBank, creditCard, transferTax, transferZus, fxExchange, scanPay, topUpPhone]
        for action in offerActions {
            switch action {
            case .donations:
                actions.insert(action, at: 6)
            default: break
            }
        }
        return actions
    }
}
