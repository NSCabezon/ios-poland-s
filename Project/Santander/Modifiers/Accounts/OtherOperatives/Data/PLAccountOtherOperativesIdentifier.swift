//
//  PLAccountOtherOperativesIdentifier.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import Foundation

public enum PLAccountOtherOperativesIdentifier: String, Codable {
    case addBanks = "ADD_BANKS"
    case changeAliases = "CHANGE_ALIASES"
    case changeAccount = "CHANGE_ACCOUNT"
    case generateQRCode = "GENERATE_QR"
    case alerts24 = "ALERTS_NOTIFICATION"
    case creditCardRepayment = "CREDIT_CARD_REPAYMENT"
    case editGoal = "EDIT_GOAL"
    case history = "HISTORY"
    case accountStatement = "ACCOUNT_STATEMENT"
    case customerService = "CUSTOMER_SERVICE"
    case openDeposit = "OPEN_DEPOSIT"
    case fxExchange = "FX_EXCHANGE"
    case memberGetMember = "MEMBER_GET_MEMBER"
    case saving_goals = "SAVING_GOALS"
}
