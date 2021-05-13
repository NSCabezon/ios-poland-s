//
//  DemoInterpreter.swift
//  PTCommons
//
//  Created by Luis Escámez Sánchez on 17/03/2021.
//

import Foundation

public protocol DemoUserProtocol {
    func isDemoUser(userName: String) -> Bool
    func getAnswerNumber(serviceName: PTLocalServiceName) -> Int
    var isDemoModeAvailable: Bool { get }
}

public class DemoUserInterpreter: DemoUserProtocol {
    public var isDemoModeAvailable: Bool
    static let demoUser = "12345678Z"
//    let bsanDataProvider: BSANDataProvider
    let defaultDemoUser: String

//    public init(bsanDataProvider: BSANDataProvider, defaultDemoUser: String, demoModeAvailable: Bool?) {
    public init(defaultDemoUser: String, demoModeAvailable: Bool?) {
//        self.bsanDataProvider = bsanDataProvider
        self.defaultDemoUser = defaultDemoUser
        self.isDemoModeAvailable = demoModeAvailable ?? false
    }

    public func isDemoUser(userName: String) -> Bool {
        return userName.uppercased() == DemoUserInterpreter.demoUser
    }
    
    public func getAnswerNumber(serviceName: PTLocalServiceName) -> Int {
        return PTLocalAnswerType.success.rawValue
    }
}

public enum PTLocalAnswerType: Int {
    case success = 0
    case error = 1
}

public enum PTLocalServiceName: String {
    case loginIDP = "login_idp"
    case loginLOS = "login_los"
    case logout = "revoke_token"
    case registerPIN = "register_pin"
    case loginPIN = "login_pin"
    case validatePINChallenge = "validate_pin_challenge"
    case cardsTransactions = "cards_transactions"
    case globalPosition = "global_position"
    case retailAccounts = "retail_accounts"
    case topUps = "mobile_topups"
    case topUpsPayments = "topups_scheduled_payments"
    case topUpsScheduledPayments = "payments_scheduled_payments"
    case customers = "customers"
    case mbwayCards = "mbway_cards"
    case mbwaySimultaion = "mbway_simulation"
    case mbwayExecution = "mbway_execution"
    case mbwayRecentContacts = "mbway_recent_contacts"
    case bankCalculate = "bank_calculate"
    case cardAlias = "card_alias"
    case simulatePayment = "simulate_payment"
    case payees
    case internalTranfer = "internal_transfer_simulate_payment"
}
