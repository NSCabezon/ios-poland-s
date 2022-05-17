//
//  PLSavingProductOption.swift
//  Santander
import CoreDomain
import CoreFoundationLib

enum PLSavingProductOption: String, CaseIterable {

    case sendMoney = "SEND_MONEY"
    case sendMoneyFromSrc = "SEND_MONEY_FROM_SRC"
    case savingDetails = "SAVING_DETAILS"
    case termDetails = "TERM_DETAILS"
    case savingGoals = "SAVING_GOALS"
    case openTermDeposit = "OPEN_DEPOSIT"
    case closeTermDeposit = "CLOSE_DEPOSIT"
    case customerService = "CUSTOMER_SERVICE"
    case alerts24 = "ALERTS_24"
    case changeAlias = "CHANGE_ALIAS"
    case ourOffer = "OFFER"
    case statementHistory = "STATEMENT_HISTORY"

    // swiftlint:disable cyclomatic_complexity
    func order() -> Int {
        switch self {
        case .sendMoney:
            return 1
        case .sendMoneyFromSrc:
            return 1
        case .savingDetails:
            return 2
        case .termDetails:
            return 2
        case .savingGoals:
            return 3
        case .openTermDeposit:
            return 4
        case .closeTermDeposit:
            return 5
        case .customerService:
            return 6
        case .alerts24:
            return 7
        case .changeAlias:
            return 8
        case .ourOffer:
            return 9
        case .statementHistory:
            return 10
        }
    }
    // swiftlint:enable cyclomatic_complexity

    /// Differentiate if the action is valid for goals/terms/savings...
    func isValidAccountSubType(typeToCheck: PLSavingTransactionsRepositoryProductType) -> Bool {
        switch self {
        case .sendMoney:
            return typeToCheck == .savingProduct
        case .sendMoneyFromSrc:
            return typeToCheck == .term
        case .savingDetails:
            return typeToCheck == .savingProduct
        case .termDetails:
            return typeToCheck == .term
        case .openTermDeposit, .closeTermDeposit:
            return typeToCheck == .term
        default:
            return true
        }
    }
}

extension PLSavingProductOption {
    public var title: String {
       switch self {
       case .sendMoney:
           return "savingOption_button_sendMoney"
       case .sendMoneyFromSrc:
           return "savingOption_button_sendMoney"
       case .savingDetails, .termDetails:
           return "savingOption_button_accountDetails"
       case .savingGoals:
           return "savingOption_button_savingGoals"
       case .openTermDeposit:
           return "savingOption_button_openTermDeposit"
       case .closeTermDeposit:
           return "savingOption_button_closeTermDeposit"
       case .customerService:
           return "frequentOperative_button_customerService"
       case .alerts24:
           return "accountOption_button_alerts24"
       case .changeAlias:
           return "cardsOption_button_changeAlias"
       case .ourOffer:
           return "frequentOperative_button_contract"
       case .statementHistory:
           return "cardsOption_button_statementHistory"
       }
    }

    public var iconName: String {
        switch self {
        case .sendMoney:
            return "icnSendMoney"
        case .sendMoneyFromSrc:
            return "icnSendMoney"
        case .savingDetails, .termDetails:
            return "icnCheckExtract"
        case .savingGoals:
            return "icnSavingGoals"
        case .openTermDeposit:
            return "icnOpenTermDeposit"
        case .closeTermDeposit:
            return "icnOpenTermDeposit"
        case .customerService:
            return "icnCustomerService"
        case .alerts24:
            return "icnAlertConfig"
        case .changeAlias:
            return "icnChangeAlias"
        case .ourOffer:
            return "icnOffer"
        case .statementHistory:
            return "icnStatementHistory"
        }
    }

    public var iconColor: UIColor {
        switch self {
        case .sendMoney, .sendMoneyFromSrc, .savingDetails, .termDetails:
            return .bostonRed
        case .savingGoals, .openTermDeposit, .closeTermDeposit, .customerService:
            return .bostonRed
        case .alerts24, .changeAlias, .ourOffer, .statementHistory:
            return .bostonRed
        }
    }

    public var accessibilityIdentifier: String {
        switch self {
        case .sendMoney:
            return AccessibilitySavingsShortcuts.sendMoney.rawValue
        case .sendMoneyFromSrc:
            return AccessibilitySavingsShortcuts.sendMoneyFromSrc.rawValue
        case .savingDetails:
            return AccessibilitySavingsShortcuts.savingDetails.rawValue
        case .termDetails:
            return AccessibilitySavingsShortcuts.termDetails.rawValue
        case .savingGoals:
            return AccessibilitySavingsShortcuts.savingGoals.rawValue
        case .openTermDeposit:
            return AccessibilitySavingsShortcuts.openTermDeposit.rawValue
        case .closeTermDeposit:
            return AccessibilitySavingsShortcuts.closeTermDeposit.rawValue
        case .customerService:
            return AccessibilitySavingsShortcuts.customerService.rawValue
        case .alerts24:
            return AccessibilitySavingsShortcuts.alerts24.rawValue
        case .changeAlias:
            return AccessibilitySavingsShortcuts.changeAlias.rawValue
        case .ourOffer:
            return AccessibilitySavingsShortcuts.ourOffer.rawValue
        case .statementHistory:
            return AccessibilitySavingsShortcuts.statementHistory.rawValue
        }
    }

    public var type: SavingProductOptionType {
        switch self {
        case .sendMoney:
            return .sendMoney
        case .sendMoneyFromSrc, .savingDetails, .termDetails, .savingGoals, .openTermDeposit, .closeTermDeposit, .customerService, .alerts24, .changeAlias, .ourOffer:
            return .custom(identifier: self.rawValue.lowercased())
        case .statementHistory:
            return .statements
        }
    }

    public var section: SavingsActionSection {
        switch self {
        case .sendMoney:
            return .settings
        case .sendMoneyFromSrc:
            return .settings
        case .savingDetails:
            return .settings
        case .termDetails:
            return .settings
        case .savingGoals:
            return .settings
        case .openTermDeposit:
            return .settings
        case .closeTermDeposit:
            return .settings
        case .customerService:
            return .queries
        case .alerts24:
            return .settings
        case .changeAlias:
            return .settings
        case .ourOffer:
            return .offer
        case .statementHistory:
            return .queries
        }
    }
}
