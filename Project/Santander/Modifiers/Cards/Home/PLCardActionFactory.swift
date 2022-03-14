//
//  PLCardActionFactory.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 12/1/22.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import Cards
import CreditCardRepayment
import CoreImage
import FinantialTimeline
import PassKit

public final class PLCardActionFactory: CardActionFactoryProtocol {
    private let dependenciesResolver: DependenciesResolver
    public var isOTPExcepted: Bool = false
    public var isPb: Bool = false
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private enum Constants {
        static let numberOfElementsShownOnHome = 4
        static let defaultCardActions: [PLCardActionIdentifier] = [.cardDetails, .alerts24, .blockedFunds, .changeAlias]
    }

    private lazy var defaultCardActions: [CardActionType] = {
        return Constants.defaultCardActions.compactMap { return Self.cardActionType(for: $0, isDisabled: false) }
    }()

    public func getOtherOperativesCardActions(for card: CardEntity,
                                              offers: [PullOfferLocation: OfferEntity],
                                              cardActions: (CardAction, CardAction),
                                              isOTPExcepted: Bool) -> [CardActionViewModel] {
        let viewModel = CardViewModel(card,
                                      applePayState: .notSupported,
                                      isMapEnable: false,
                                      isEnableCashWithDrawal: false,
                                      dependenciesResolver: self.dependenciesResolver,
                                      maskedPAN: false)
        self.isOTPExcepted = isOTPExcepted
        let array = self.getCardHomeActions(for: viewModel, offers: offers, cardActions: cardActions, onlyFourActions: false)
        return Array(array.dropFirst(Constants.numberOfElementsShownOnHome))
    }

    public func getCardHomeActions(for viewModel: CardViewModel,
                                   offers: [PullOfferLocation: OfferEntity],
                                   cardActions: (CardAction, CardAction),
                                   onlyFourActions: Bool = true,
                                   scaDate: Date? = nil) -> [CardActionViewModel] {

        let actionList = self.cardActions(for: viewModel.cardEntity)
        return actionList.createCardActionViewModels(entity: viewModel.cardEntity, cardActions: cardActions)
    }
}

private extension PLCardActionFactory {

    func cardActions(for entity: CardEntity) -> [CardActionType] {

        guard let productActionMatrix = self.dependenciesResolver.resolve(forOptionalType: ProductActionsShortcutsMatrix.self),
              let actionsFromService = productActionMatrix.getOperationsProducts(type: .cards, contract: entity.cardContract) else {
                  return self.defaultCardActions
        }

        let filteredCardActionsFromService = actionsFromService.filter { $0.state == ProductActionsShortcutsState.enabled.rawValue }
        let cardActions: [CardActionType] = filteredCardActionsFromService.compactMap {
            guard let cardActionIdentifier = PLCardActionIdentifier.mapped($0.id) else { return nil }
            if cardActionIdentifier == .addToPay {
                return cardActionApplePay(for: entity, isDisabled: ($0.state == ProductActionsShortcutsState.disabled.rawValue))
            }
            return Self.cardActionType(for: cardActionIdentifier, isDisabled: ($0.state == ProductActionsShortcutsState.disabled.rawValue))
        }

        return cardActions.sortedCardActions(for: entity.cardType)
    }

    static func cardActionType(for actionIdentifier: PLCardActionIdentifier,
                               isDisabled: Bool) -> CardActionType? {

        switch actionIdentifier {
        case .addToPay:
            return .applePay
        case .unblock:
            return .onCard
        case .block:
            return .offCard
        case .cardDetails:
            return .detail
        case .history:
            return nil
        case .activate,
                .alerts24,
                .atmPackage,
                .blockedFunds,
                .cancelCard,
                .changeAlias,
                .creditCardRepayment,
                .creditLimitIncrease,
                .customerService,
                .generateGR,
                .managePin,
                .modifyLimits,
                .multicurrency,
                .sendMoneyFromSrc,
                .offer,
                .repayment,
                .useAbroad,
                .viewCvv,
                .viewStatements:

            guard let values = actionIdentifier.customCardActionValues() else { return nil }
            let customAction: CardActionType = .custome(CustomCardActionValues(identifier: actionIdentifier.rawValue,
                                                                               localizedKey: values.localizedKey,
                                                                               icon: values.icon,
                                                                               section: values.section,
                                                                               location: "",
                                                                               isDisabled: { _ in return isDisabled }))
            return customAction
        }
    }

    func cardActionApplePay(for entity: CardEntity,
                            isDisabled: Bool) -> CardActionType? {

        var addedApple = false
        if let virtualPan = entity.dto.contract?.contractNumber,
           let sufix = virtualPan.substring(ofLast: 4) {
            addedApple = PKPassLibrary().containsActivatedPaymentPass(primaryAccountNumberSuffix: sufix)
        }

        var localizedKey: String
        var icon: String

        switch (isDisabled, addedApple) {
        case (_, true):
            localizedKey = "cardsOption_button_addedApple"
            icon = "icnApayCheck"
        case (true, false):
            localizedKey = "cardsOption_button_addApple"
            icon = "icnApayDisactive"
        case (false, false):
            localizedKey = "cardsOption_button_addApple"
            icon = "icnApay"
        }

        return CardActionType.custome(CustomCardActionValues(identifier: PLCardActionIdentifier.addToPay.rawValue,
                                                             localizedKey: localizedKey,
                                                             icon: icon,
                                                             section: "otherOperatives",
                                                             location: nil,
                                                             isDisabled: { _ in return isDisabled }))
    }
}

private extension Array where Element == CardActionType {

    enum Constants {
        static let creditCardActionsHomePriority: [PLCardActionIdentifier] = [.activate, .unblock, .block, .sendMoneyFromSrc, .repayment]
        static let debitCardActionsHomePriority: [PLCardActionIdentifier] = [.activate, .unblock, .block, .managePin, .modifyLimits, .addToPay]
    }

    func sortedCardActions(for cardType: CardDOType) -> [CardActionType] {
        let actionsIds: [PLCardActionIdentifier]
        switch cardType {
        case .debit:
            actionsIds = Constants.debitCardActionsHomePriority
        case .credit:
            actionsIds = Constants.creditCardActionsHomePriority
        case .prepaid:
            actionsIds = []
        }

        let cardActions = actionsIds.compactMap { return PLCardActionFactory.cardActionType(for: $0, isDisabled: false) }
        let intersection = cardActions.filter { self.contains($0) }
        let diference = self.filter { !cardActions.contains($0) }

        return intersection + diference
    }

    func createCardActionViewModels(entity: CardEntity,
                                    cardActions: (CardAction, CardAction)) -> [CardActionViewModel] {

        var actions: [CardActionViewModel] = []
        for actionType in self {
            var isDisabled = false
            if case .custome(let values) = actionType {
                isDisabled = values.isDisabled(entity)
            }

            // NOTE: Remove this condition when Android is ready to show disabled actions
            if isDisabled == false {
                let cardActionViewModel = CardActionViewModel(entity: entity,
                                                              type: actionType,
                                                              action: cardActions.0,
                                                              isDisabled: isDisabled,
                                                              renderingMode: isDisabled ? .alwaysTemplate : .alwaysOriginal)
                actions.append(cardActionViewModel)
            }
        }
        return actions
    }
}
