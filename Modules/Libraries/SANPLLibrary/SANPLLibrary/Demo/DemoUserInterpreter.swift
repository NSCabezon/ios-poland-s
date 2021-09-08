//
//  DemoUserInterpreter.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public protocol DemoUserProtocol {
    func isDemoUser(userName: String) -> Bool
    var isDemoModeAvailable: Bool { get }
}

public class DemoUserInterpreter: DemoUserProtocol {
    public var isDemoModeAvailable: Bool
    static let demoUser = "12345678Z"
    let bsanDataProvider: BSANDataProvider
    let defaultDemoUser: String

    public init(bsanDataProvider: BSANDataProvider, defaultDemoUser: String, demoModeAvailable: Bool = false) {
        self.bsanDataProvider = bsanDataProvider
        self.defaultDemoUser = defaultDemoUser
        self.isDemoModeAvailable = demoModeAvailable
    }

    public func isDemoUser(userName: String) -> Bool {
        return userName.uppercased() == DemoUserInterpreter.demoUser
    }
}

public enum PLLocalAnswerType: Int {
    case success = 0
    case error = 1
}

public enum PLLocalServiceName: String {
    case globalPosition = "globalPosition"
    case login = "login"
    case loanDetails = "loanDetails"
    case loanTransactions = "loanTransactions"
    case loanInstallments = "loanInstallments"
    case accountDetails = "accountDetails"
    case swiftBranches = "swiftBranches"
    case cardWithHoldings = "cardWithholdings"
    case accountTransactions = "accountTransactions"
    case searchbycard = "searchbycard"
    case pubKey = "pub_key"
    case authenticateInit = "authenticate_init"
    case authenticate = "authenticate"
    case registerDeviceTrustDevice = "registerDeviceTrustDevice"
    case registerSoftwareToken = "registerSoftwareToken"
    case registerIVR = "registerIVR"
    case registerConfirmationCode = "registerConfirmationCode"
    case devices = "devices"
    case registerConfirm = "registerConfirm"
    case customerIndividual = "customerIndividual"
}
