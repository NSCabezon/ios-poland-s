//
//  PLCardHomeActionModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 5/7/21.
//

import Cards
import CoreFoundationLib
import UI
import Commons
import CreditCardRepayment
import PLCommons
import PLCommonOperatives
import PersonalArea

enum PLCardHomeActionIdentifier: String {
    case sendMoneyPL = "SendMoneyPoland"
    case repayInInstallmentsPL = "REPAYMENT"
    case cardRepaymentPL = "CardRepaymentPoland"
    case changeLimitPL = "MODIFY_LIMITS"
    case changeAliasesPL = "ChangeAliasesPoland"
    case generateQRCodePL = "GenerateQRCodePL"
    case alerts24PL = "ALERTS_NOTIFICATION"
    case customerServicePL = "CUSTOMER_SERVICE"
    case blockedFundsPL = "BlockedFundsPoland"
    case viewStatementsPL = "STATEMENT_HISTORY"
    case managePinPL = "MANAGE_PIN"
    case usingCardAbroadPL = "USE_ABROAD"
    case refundForPurchasesPL = "RefundForPurchasesPoland"
    case exploreProductsPL = "ExploreProductsPoland"
    case creditLimitIncreasePL = "CreditLimitIncreasePoland"
    case multicurrencyPL = "MULTICURRENCY"
    case atmPackagePL = "ATM_PACKAGE"
    case blockPL = "CANCEL_CARD"
    case cvvPL = "CvvPoland"
    case cardActivatePL = "CARD_ACTIVATION"
}

final class PLCardHomeActionModifier: CardHomeActionModifier, CardBoardingActionModifierProtocol {
    private let sendMoneyPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.sendMoneyPL.rawValue,
                               localizedKey: "accountOption_button_transfer",
                               icon: "icnSendMoney",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )
 
    private let repayInInstallmentsPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.repayInInstallmentsPL.rawValue,
                               localizedKey: "cardsOption_button_repayInstallments",
                               icon: "icnRatio",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive
                               })
    )

    private let cardRepaymentPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.cardRepaymentPL.rawValue,
                               localizedKey: "pl_cardsOption_button_cardRepayment",
                               icon: "icnDepositCard",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive
                               })
    )

    private let changeLimitsPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.changeLimitPL.rawValue,
                               localizedKey: "cardsOption_button_modifyCard",
                               icon: "icnChangeLimits",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let changeAliasesPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.changeAliasesPL.rawValue,
                               localizedKey: "cardsOption_button_changeAlias",
                               icon: "icnChangeAlias",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let generateQRCodePL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.generateQRCodePL.rawValue,
                               localizedKey: "accountOption_button_generateQR",
                               icon: "icnQr",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let alerts24PL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.alerts24PL.rawValue,
                               localizedKey: "pl_cardsOption_button_Alerts24",
                               icon: "icnAlertConfig",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let customerServicePL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.customerServicePL.rawValue,
                               localizedKey: "frequentOperative_button_customerService",
                               icon: "icnCustomerService",
                               section: "otherOperatives",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )
    
    private let blockedFundsPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.blockedFundsPL.rawValue,
                               localizedKey: "cardsOption_button_blockFunds",
                               icon: "icnBlockedFunds",
                               section: "queries",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive
                               })
    )

    private let viewStatementsPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.viewStatementsPL.rawValue,
                               localizedKey: "pl_cardsOption_button_viewStatements",
                               icon: "icnStatementHistory",
                               section: "queries",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive
                               })
    )

    private let managePinPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.managePinPL.rawValue,
                               localizedKey: "pl_cardsOption_button_managePin",
                               icon: "icnManagePin",
                               section: "security",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let viewCvvPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.cvvPL.rawValue,
                               localizedKey: "cardsOption_button_cvv",
                               icon: "icnCvv",
                               section: "security",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let usingCardAbroadPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue,
                               localizedKey: "cardsOption_button_usingCardAbroad",
                               icon: "icnCardAbroad",
                               section: "security",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let exploreProductsPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.exploreProductsPL.rawValue,
                               localizedKey: "frequentOperative_button_contract",
                               icon: "icnOffer",
                               section: "contract",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isContractCancelled
                               })
    )

    private let refundForPurchasesPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.refundForPurchasesPL.rawValue,
                               localizedKey: "pl_cardsOption_button_refundPurchases",
                               icon: "icnRefundForPurchases",
                               section: "contract",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let creditLimitIncreasePL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.creditLimitIncreasePL.rawValue,
                               localizedKey: "pl_cardsOption_button_creditLimitIncrease",
                               icon: "icnCreditLimitIncrease",
                               section: "contract",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let multicurrencyPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.multicurrencyPL.rawValue,
                               localizedKey: "pl_cardsOption_button_multicurrency",
                               icon: "icnMulticurrency",
                               section: "contract",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let atmPackagePL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.atmPackagePL.rawValue,
                               localizedKey: "pl_cardsOption_button_atmPackage",
                               icon: "icnAtmPackage",
                               section: "contract",
                               location: "",
                               isDisabled: { card in
                                return card.isInactive || card.isDisabled
                               })
    )

    private let blockPL: CardActionType = .custome(
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.blockPL.rawValue,
                               localizedKey: "cardsOption_button_block",
                               icon: "icnBlockCard",
                               section: "security",
                               location: "",
                               isDisabled: { card in
                                return card.isContractCancelled
                               })
    )

    override func getCreditCardHomeActions() -> [CardActionType] {
        return [.onCard, .offCard, .enable, sendMoneyPL, repayInInstallmentsPL, cardRepaymentPL, .applePay, changeLimitsPL, changeAliasesPL, generateQRCodePL, alerts24PL, customerServicePL, .detail, blockedFundsPL, viewStatementsPL, managePinPL, blockPL, viewCvvPL, usingCardAbroadPL, refundForPurchasesPL, exploreProductsPL, creditLimitIncreasePL]
    }

    override func getDebitCardHomeActions() -> [CardActionType] {
        return [.onCard, .offCard, .enable, managePinPL, changeLimitsPL, .applePay, alerts24PL, .detail, blockedFundsPL, blockPL, viewCvvPL, usingCardAbroadPL, exploreProductsPL, multicurrencyPL, atmPackagePL]
    }

    override func didSelectAction(_ action: CardActionType, _ entity: CardEntity) {
        switch action {
        case .offCard:
            goToCardBlock(entity)
        case .onCard:
            goToCardUnblock(entity)
        case cardRepaymentPL:
            openCreditCardRepayment(creditCardEntity: entity)
        case .enable:
            onCardEnable(creditCardEntity: entity)
        default:
            switch action.trackName {
            case PLCardHomeActionIdentifier.blockPL.rawValue,
                PLCardHomeActionIdentifier.multicurrencyPL.rawValue,
                PLCardHomeActionIdentifier.managePinPL.rawValue,
                PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue,
                PLCardHomeActionIdentifier.changeLimitPL.rawValue,
                PLCardHomeActionIdentifier.repayInInstallmentsPL.rawValue,
                PLCardHomeActionIdentifier.customerServicePL.rawValue,
                PLCardHomeActionIdentifier.atmPackagePL.rawValue,
                PLCardHomeActionIdentifier.alerts24PL.rawValue,
                PLCardHomeActionIdentifier.viewStatementsPL.rawValue:
                guard let trackName = action.trackName else { return }
                let cardData = getCardData(identifier: getType(identifier: trackName))
                if let isAvailable = cardData.isAvailable, !isAvailable {
                    Toast.show(localized("generic_alert_notAvailableOperation"))
                    return
                }
                showWebView(identifier: trackName, entity: entity, cardData: cardData)
            case PLCardHomeActionIdentifier.changeAliasesPL.rawValue:
                goToPGProductsCustomization()
                break
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        }
    }

    override func rearrangeApplePayAction() -> Bool {
        return false
    }
    
    func getCardData(identifier: PLCardWebViewType) -> PLAccountOtherOperativesData {
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.cardsOptions, let data = getCardOtherOperativesEntity(list: list, identifier: identifier) else { return PLAccountOtherOperativesData(identifier: nil, link: nil, isAvailable: nil, httpMethod: nil, parameter: nil) }
        return data
    }

    func getCardOtherOperativesEntity(list: [PLAccountOtherOperativesDTO], identifier: PLCardWebViewType) -> PLAccountOtherOperativesData? {
        var entity: PLAccountOtherOperativesData?
        for dto in list {
            if dto.id == PLCardHomeActionIdentifier.blockPL.rawValue, identifier == .cancel {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.blockPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.multicurrencyPL.rawValue, identifier == .multicurrency {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.multicurrencyPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.managePinPL.rawValue, identifier == .pin {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.managePinPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue, identifier == .useAbroad {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.changeLimitPL.rawValue, identifier == .changeLimits {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.changeLimitPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.viewStatementsPL.rawValue, identifier == .viewStatements {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.viewStatementsPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.cardActivatePL.rawValue, identifier == .enable {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.cardActivatePL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.repayInInstallmentsPL.rawValue, identifier == .repayInInstallments {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.repayInInstallmentsPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.atmPackagePL.rawValue, identifier == .atmPackage {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.atmPackagePL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.alerts24PL.rawValue, identifier == .alerts24 {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.alerts24PL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method), isFullScreen: dto.isFullScreen)
                break
            } else if dto.id == PLCardHomeActionIdentifier.customerServicePL.rawValue, identifier == .customerService {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.customerServicePL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method))
                break
            }
        }
        return entity
    }

    private func getHttpMethod(method: String?) -> HTTPMethodType {
        if method == "GET" {
            return .get
        } else {
            return .post
        }
    }

    private func showWebView(identifier: String, entity: CardEntity, cardData: PLAccountOtherOperativesData) {
        switch identifier {
        case PLCardHomeActionIdentifier.managePinPL.rawValue,
            PLCardHomeActionIdentifier.changeLimitPL.rawValue,
            PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue,
            PLCardHomeActionIdentifier.cardActivatePL.rawValue,
            PLCardHomeActionIdentifier.customerServicePL.rawValue,
            PLCardHomeActionIdentifier.multicurrencyPL.rawValue:
            
            let useCase = self.dependenciesResolver.resolve(for: GetBasePLWebConfigurationUseCaseProtocol.self)
            guard let url = cardData.link,
                  let vpan = entity.dto.contract?.contractNumber else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }
            let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url.replace("{$VPAN}", vpan), method: cardData.httpMethod ?? .get, isFullScreenEnabled: cardData.isFullScreen ?? true)
            Scenario(useCase: useCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { result in
                    let linkHandler = PLWebviewCustomLinkHandler(configuration: result.configuration)
                    let coordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
                    coordinator.showWebView(handler: linkHandler)
                }
        default:
            let input = GetPLCardsOtherOperativesWebConfigurationUseCaseInput(type: getType(identifier: identifier), cardEntity: entity, cardData: cardData)
            let useCase = self.dependenciesResolver.resolve(for: GetPLCardsOtherOperativesWebConfigurationUseCase.self)
            Scenario(useCase: useCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { result in
                    self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
                }
        }
    }
    
    private func getType(identifier: String) -> PLCardWebViewType {
        switch identifier {
        case PLCardHomeActionIdentifier.blockPL.rawValue:
            return .cancel
        case PLCardHomeActionIdentifier.multicurrencyPL.rawValue:
            return .multicurrency
        case PLCardHomeActionIdentifier.managePinPL.rawValue:
            return .pin
        case PLCardHomeActionIdentifier.usingCardAbroadPL.rawValue:
            return .useAbroad
        case PLCardHomeActionIdentifier.changeLimitPL.rawValue:
            return .changeLimits
        case PLCardHomeActionIdentifier.viewStatementsPL.rawValue:
            return .viewStatements
        case PLCardHomeActionIdentifier.cardActivatePL.rawValue:
            return .enable
        case PLCardHomeActionIdentifier.repayInInstallmentsPL.rawValue:
            return .repayInInstallments
        case PLCardHomeActionIdentifier.customerServicePL.rawValue:
            return .customerService
        case PLCardHomeActionIdentifier.atmPackagePL.rawValue:
            return .atmPackage
        case PLCardHomeActionIdentifier.alerts24PL.rawValue:
            return .alerts24
        default:
            return .cancel
        }
    }
    
    private func openCreditCardRepayment(creditCardEntity: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CreditCardRepaymentModuleCoordinator.self)
        coordinator.start(with: creditCardEntity)
    }
    
    private func onCardEnable(creditCardEntity: CardEntity) {
        let identifier = PLCardHomeActionIdentifier.cardActivatePL.rawValue
        let cardData = getCardData(identifier: getType(identifier: identifier))
        if let isAvailable = cardData.isAvailable, !isAvailable {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }
        showWebView(identifier: identifier, entity: creditCardEntity, cardData: cardData)
    }
    
    private func onAlerts24(entity: CardEntity) {
        let identifier = PLCardHomeActionIdentifier.alerts24PL.rawValue
        let cardData = getCardData(identifier: getType(identifier: identifier))
        if let isAvailable = cardData.isAvailable, !isAvailable {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }
        showWebView(identifier: identifier, entity: entity, cardData: cardData)
    }
}

private extension PLCardHomeActionModifier {
    func goToCardBlock(_ card: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self)
        coordinator.didSelectAction(.offCard, card)
    }

    func goToCardUnblock(_ card: CardEntity) {
        let coordinator = self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self)
        coordinator.didSelectAction(.onCard, card)
    }
    
    func goToPGProductsCustomization() {
        let coordinator = dependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
}
