//
//  PLCardActionIdentifier.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 27/1/22.
//

import Foundation

enum PLCardActionIdentifier: String, CaseIterable {
    case activate = "ACTIVATE"
    case cardActivation = "CARD_ACTIVATION"
    case addToPay = "ADD_TO_PAY"
    case unblock = "UNBLOCK"
    case modifyLimits = "MODIFY_LIMITS"
    case changeAlias = "CHANGE_ALIAS"
    case generateGR = "GENERATE_QR"
    case alerts24 = "ALERTS_24"
    case customerService = "CUSTOMER_SERVICE"
    case cardDetails = "CARD_DETAILS"
    case blockedFunds = "BLOCKED_FUNDS"
    case viewStatements = "VIEW_STATEMENTS"
    case history = "HISTORY"
    case offer = "OFFER"
    case creditLimitIncrease = "CREDIT_LIMIT_INCREASE"
    case managePin = "MANAGE_PIN"
    case cancelCard = "CANCEL_CARD"
    case viewCvv = "VIEW_CVV"
    case useAbroad = "USE_ABROAD"
    case block = "BLOCK"
    case sendMoneyFromSrc = "SEND_MONEY_FROM_SRC"
    case atmPackage = "ATM_PACKAGE"
    case creditCardRepayment = "CREDIT_CARD_REPAYMENT"
    case repayment = "REPAYMENT"
    case multicurrency = "MULTICURRENCY"

    static func mapped(_ identifier: String) -> PLCardActionIdentifier? {
        return self.allCases.first { $0.rawValue == identifier }
    }

    typealias CustomCardActionConfiguration = (localizedKey: String, icon: String, section: String)
    // swiftlint:disable cyclomatic_complexity
    func customCardActionValues() -> CustomCardActionConfiguration? {
        switch self {
        case .addToPay,
                .unblock,
                .cardDetails,
                .history,
                .block:
            return nil
        case .sendMoneyFromSrc:
            return ("transaction_buttonOption_transfer", "icnSendMoney", "otherOperatives")
        case .activate, .cardActivation:
            return ("cardsOption_button_activate", "icnActivate", "otherOperatives")
        case .modifyLimits:
            return ("cardsOption_button_modifyCard", "icnChangeLimits", "otherOperatives")
        case .changeAlias:
            return ("cardsOption_button_changeAlias", "icnChangeAlias", "otherOperatives")
        case .generateGR:
            return ("accountOption_button_generateQR", "icnQr", "otherOperatives")
        case .alerts24:
            return ("pl_cardsOption_button_Alerts24", "icnAlertConfig", "otherOperatives")
        case .customerService:
            return ("accountOption_button_customerService", "icnCustomerService", "otherOperatives")
        case .blockedFunds:
            return ("cardsOption_button_blockFunds", "icnBlockedFunds", "queries")
        case .viewStatements:
            return ("pl_cardsOption_button_viewStatements", "icnStatementHistory", "queries")
        case .offer:
            return ("frequentOperative_button_contract", "icnOffer", "contract")
        case .creditLimitIncrease:
            return ("pl_cardsOption_button_creditLimitIncrease", "icnCreditLimitIncrease", "contract")
        case .managePin:
            return ("pl_cardsOption_button_managePin", "icnManagePin", "security")
        case .cancelCard:
            return ("cardsOption_button_block", "icnBlockCard", "security")
        case .viewCvv:
            return ("cardsOption_button_cvv", "icnCvv", "security")
        case .useAbroad:
            return ("cardsOption_button_usingCardAbroad", "icnCardAbroad", "security")
        case .atmPackage:
            return ("pl_cardsOption_button_atmPackage", "icnAtmPackage", "contract")
        case .creditCardRepayment:
            return ("pl_cardsOption_button_cardRepayment", "icnDepositCard", "otherOperatives")
        case .repayment:
            return ("cardsOption_button_repayInstallments", "icnRatio", "otherOperatives")
        case .multicurrency:
            return ("pl_cardsOption_button_multicurrency", "icnMulticurrency", "contract")
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
