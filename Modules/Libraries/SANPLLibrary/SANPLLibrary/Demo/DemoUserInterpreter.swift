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
    var expectedResponse: Int { get }
}

public class DemoUserInterpreter: DemoUserProtocol {
    public var isDemoModeAvailable: Bool
    static let demoUser = "12345678Z"
    let bsanDataProvider: BSANDataProvider
    let defaultDemoUser: String
    private let expectedAnswer: Int?
    public var expectedResponse: Int {
        return expectedAnswer ?? 0
    }
    
    public init(bsanDataProvider: BSANDataProvider, defaultDemoUser: String, demoModeAvailable: Bool = false, expectedAnswer: Int? = 0) {
        self.bsanDataProvider = bsanDataProvider
        self.defaultDemoUser = defaultDemoUser
        self.isDemoModeAvailable = demoModeAvailable
        self.expectedAnswer = expectedAnswer
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
    case beforeLogin = "before-login"
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
    case pendingChallenge = "pendingChallenge"
    case confirmChallenge = "confirmChallenge"
    case registerDeviceTrustDevice = "registerDeviceTrustDevice"
    case registerSoftwareToken = "registerSoftwareToken"
    case registerIVR = "registerIVR"
    case registerConfirmationCode = "registerConfirmationCode"
    case devices = "devices"
    case registerConfirm = "registerConfirm"
    case customerIndividual = "customerIndividual"
    case notificationTokenRegister = "notificationTokenRegister"
    case cardDetail = "cardDetail"
    case accountsForDebit = "accountsForDebit"
    case getPayees
    case recentRecipients
    case ibanValidation = "ibanValidation"
    case cardBlock
    case cardUnblock
    case cardDisable
    case trustedDeviceInfo = "trustedDeviceInfo"
    case checkFinalFee = "checkFinalFee"
}
