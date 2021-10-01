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
    case multicurrencyPL = "MulticurrencyPoland"
    case atmPackagePL = "AtmPackagePoland"
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
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.creditLimitIncreasePL.rawValue,
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
        CustomCardActionValues(identifier: PLCardHomeActionIdentifier.atmPackagePL.rawValue,
                               localizedKey: "cardsOption_button_block",
                               icon: "icnBlockCard",
                               section: "security",
                               location: "",
                               isDisabled: { card in
                                return card.isContractCancelled
                               })
    )

    override func getCreditCardHomeActions() -> [CardActionType] {
        return [.onCard, .offCard, .enable, sendMoneyPL, .applePay, changeLimitsPL, changeAliasesPL, generateQRCodePL, alerts24PL, customerServicePL, .detail, blockedFundsPL, viewStatementsPL, managePinPL, blockPL, viewCvvPL, usingCardAbroadPL, refundForPurchasesPL, exploreProductsPL, creditLimitIncreasePL, repayInInstallmentsPL, cardRepaymentPL]
    }

    override func getDebitCardHomeActions() -> [CardActionType] {
        return [.onCard, .offCard, managePinPL, changeLimitsPL, .applePay, .enable, alerts24PL, .detail, blockedFundsPL, blockPL, viewCvvPL, usingCardAbroadPL, exploreProductsPL, multicurrencyPL, atmPackagePL]
    }

    override func didSelectAction(_ action: CardActionType, _ entity: CardEntity) {
        switch action {
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}
