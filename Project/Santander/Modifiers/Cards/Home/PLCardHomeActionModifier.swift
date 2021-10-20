//
//  PLCardHomeActionModifier.swift
//  Santander
//
//  Created by Rodrigo Jurado on 5/7/21.
//

import Cards
import Models
import UI
import Commons

enum PLCardHomeActionIdentifier: String {
    case sendMoneyPL = "SendMoneyPoland"
    case repayInInstallmentsPL = "RepayInInstallmentsPoland"
    case cardRepaymentPL = "CardRepaymentPoland"
    case changeLimitPL = "ChangeLimitPoland"
    case changeAliasesPL = "ChangeAliasesPoland"
    case generateQRCodePL = "GenerateQRCodePL"
    case alerts24PL = "Alerts24Poland"
    case customerServicePL = "CustomerServicePoland"
    case blockedFundsPL = "BlockedFundsPoland"
    case viewStatementsPL = "ViewStatementsPoland"
    case managePinPL = "ManagePinPoland"
    case usingCardAbroadPL = "UsingCardAbroad"
    case refundForPurchasesPL = "RefundForPurchasesPoland"
    case exploreProductsPL = "ExploreProductsPoland"
    case creditLimitIncreasePL = "CreditLimitIncreasePoland"
    case multicurrencyPL = "MULTICURRENCY"
    case atmPackagePL = "AtmPackagePoland"
    case blockPL = "CANCEL_CARD"
    case cvvPL = "CvvPoland"
}

final class PLCardHomeActionModifier: CardHomeActionModifier {
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
                               localizedKey: "accountOption_button_customerService",
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
                               localizedKey: "menu_link_contract",
                               icon: "icnExploreProducts",
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
        switch action.trackName {
        case PLCardHomeActionIdentifier.blockPL.rawValue, PLCardHomeActionIdentifier.multicurrencyPL.rawValue:
            guard let trackName = action.trackName else { return }
            let cardData = getCardData(identifier: getType(identifier: trackName))
            if let isAvailable = cardData.isAvailable, !isAvailable {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }
            showWebView(identifier: trackName, entity: entity, cardData: cardData)
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
    
    func getCardData(identifier: PLCardWebViewType) -> PLAccountOtherOperativesData {
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.cards_options, let data = getCardOtherOperativesEntity(list: list, identifier: identifier) else { return PLAccountOtherOperativesData(identifier: nil, link: nil, isAvailable: nil, httpMethod: nil, parameter: nil) }
        return data
    }

    func getCardOtherOperativesEntity(list: [PLAccountOtherOperativesDTO], identifier: PLCardWebViewType) -> PLAccountOtherOperativesData? {
        var entity: PLAccountOtherOperativesData?
        for dto in list {
            if dto.id == PLCardHomeActionIdentifier.blockPL.rawValue, identifier == .cancel {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.blockPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method))
                break
            } else if dto.id == PLCardHomeActionIdentifier.multicurrencyPL.rawValue, identifier == .multicurrency {
                entity = PLAccountOtherOperativesData(identifier: PLCardHomeActionIdentifier.multicurrencyPL.rawValue, link: dto.url, isAvailable: dto.isAvailable, httpMethod: getHttpMethod(method: dto.method))
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
        let input: GetPLCardsOtherOperativesWebConfigurationUseCaseInput
        input = GetPLCardsOtherOperativesWebConfigurationUseCaseInput(type: getType(identifier: identifier), cardEntity: entity, cardData: cardData)
        let useCase = self.dependenciesResolver.resolve(for: GetPLCardsOtherOperativesWebConfigurationUseCase.self)
        Scenario(useCase: useCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { result in
                self.dependenciesResolver.resolve(for: CardsHomeModuleCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
            }
    }
    
    private func getType(identifier: String) -> PLCardWebViewType {
        switch identifier {
        case PLCardHomeActionIdentifier.blockPL.rawValue:
            return .cancel
        case PLCardHomeActionIdentifier.multicurrencyPL.rawValue:
            return .multicurrency
        default:
            return .cancel
        }
    }
}
