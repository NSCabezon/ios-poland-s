//
//  PLAccountOtherOperativesIdentifier.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation
import UI

public enum PLAccountOperativeIdentifier: String, Codable {
    
    case transfer = "SEND_MONEY_FROM_SRC"
    case details = "ACCOUNT_DETAILS"
    case addBanks = "ADD_BANKS"
    case changeAliases = "CHANGE_ALIAS"
    case changeAccount = "CHANGE_ACCOUNT"
    case generateQRCode = "GENERATE_QR"
    case alerts24 = "ALERTS_24"
    case moneyBack = "MONEY_BACK"
    case multicurrency = "MULTICURRENCY"
    case atmPackage = "ATM_PACKAGE"
    case editGoal = "EDIT_GOAL"
    case history = "HISTORY"
    case accountStatement = "STATEMENT_HISTORY"
    case customerService = "CUSTOMER_SERVICE"
    case ourOffer = "OFFER"
    case openDeposit = "OPEN_DEPOSIT"
    case fxExchange = "FX_EXCHANGE"
    case memberGetMember = "MEMBER_GET_MEMBER"
    case savingGoals = "SAVING_GOALS"
    case externalTransfer = "SEND_MONEY_FROM_OTHER"
    case blik = "BLIK"
    
    public var icon: String {
        switch self {
        case .blik:
            return "icnBlik"
        case .externalTransfer:
            return "icnSendMoney"
        case .savingGoals:
            return "icnSavingGoals"
        case .addBanks:
            return "icnBanks"
        case .changeAliases:
            return "icnChangeAlias"
        case .changeAccount:
            return "icnChangeAccountPL"
        case .generateQRCode:
            return "icnQr"
        case .alerts24:
            return "icnAlertConfig"
        case .editGoal:
            return "icnEditGoal"
        case .moneyBack:
            return "icnMoneyBack"
        case .multicurrency:
            return "icnMulticurrency"
        case .atmPackage:
            return "icnAtmPackage"
        case .history:
            return "icnTransHistory"
        case .accountStatement:
            return "icnAccountStatements"
        case .customerService:
            return "icnCustomerService"
        case .ourOffer:
            return "icnOffer"
        case .openDeposit:
            return "icnOpenDeposit"
        case .fxExchange:
            return "icnCurrencyExchange"
        case .memberGetMember:
            return "icnMemberGetMember"
        case .details:
            return "icnDetail"
        case .transfer:
            return "icnSendMoney"
        }
    }
    
    public var textKey: String {
        switch self {
        case .blik:
            return "pl_frequentOperative_button_blik"
        case .externalTransfer:
            return "accountOption_button_transfer"
        case .savingGoals:
            return "accountOption_button_savingGoals"
        case .addBanks:
            return "accountOption_label_addBanks"
        case .changeAliases:
            return "productOption_button_changeAlias"
        case .changeAccount:
            return "accountOption_button_changeAccount"
        case .generateQRCode:
            return "accountOption_button_generateQR"
        case .alerts24:
            return "accountOption_button_alerts24"
        case .editGoal:
            return "accountOption_button_editGoal"
        case .moneyBack:
            return "accountOption_button_moneyBack"
        case .multicurrency:
            return "frequentOperative_button_multicurrency"
        case .atmPackage:
            return "frequentOperative_button_atmPackage"
        case .history:
            return "accountOption_button_transHistory"
        case .accountStatement:
            return "accountOption_button_statements"
        case .customerService:
            return "frequentOperative_button_customerService"
        case .ourOffer:
            return "frequentOperative_button_contract"
        case .openDeposit:
            return "accountOption_button_openDeposit"
        case .fxExchange:
            return "accountOption_button_currencyExchange"
        case .memberGetMember:
            return "accountOption_button_friendPlan"
        case .details:
            return "accountOption_button_detail"
        case .transfer:
            return "accountOption_button_transfer"
        }
    }
    
    public var rendering: UIImage.RenderingMode {
        switch self {
        case .blik:
            return .alwaysOriginal
        default:
            return .alwaysTemplate
        }
        
    }
}
