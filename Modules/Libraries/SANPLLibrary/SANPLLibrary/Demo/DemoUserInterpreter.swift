//
//  DemoUserInterpreter.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public protocol DemoUserProtocol {
    func isDemoUser(userName: String) -> Bool
    func getDestinationFileFor(service: PLLocalServiceName) -> (file: String, bundle: Bundle?)
    func setTestFile(_ file: String?, bundle: Bundle?)
    var isDemoModeAvailable: Bool { get }
    var expectedResponse: Int { get }
    var demoUser: String { get }
}

public class DemoUserInterpreter: DemoUserProtocol {

    public var isDemoModeAvailable: Bool
    public var demoUser: String
    let bsanDataProvider: BSANDataProvider
    private var testFile: (file: String?, bundle: Bundle?) = (nil, nil)
    private let expectedAnswer: Int?
    public var expectedResponse: Int {
        return expectedAnswer ?? 0
    }
    
    public init(bsanDataProvider: BSANDataProvider, defaultDemoUser: String, demoModeAvailable: Bool = false, expectedAnswer: Int? = 0) {
        self.bsanDataProvider = bsanDataProvider
        self.demoUser = defaultDemoUser
        self.isDemoModeAvailable = demoModeAvailable
        self.expectedAnswer = expectedAnswer
    }

    public func isDemoUser(userName: String) -> Bool {
        return userName.uppercased() == self.demoUser.uppercased()
    }
    
    public func setTestFile(_ file: String?, bundle: Bundle?) {
        self.testFile = (file, bundle)
    }
    
    public func getDestinationFileFor(service: PLLocalServiceName) -> (file: String, bundle: Bundle?) {
        return (self.testFile.file ?? service.rawValue, self.testFile.bundle)
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
    case savingsTransactions = "savingsTransactions"
    case savingDetails = "savingDetails"
    case termDetails = "termDetails"
    case changeAlias = "changeAlias"
    case searchbycard = "searchbycard"
    case pubKey = "pub_key"
    case authenticateInit = "authenticate_init"
    case authenticate = "authenticate"
    case logout = "logout"
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
    case accountsForCredit = "accountsForCredit"
    case creditCardRepaymentSend = "creditCardRepaymentSend"
    case getPayees
    case recentRecipients
    case ibanValidation = "ibanValidation"
    case cardBlock
    case cardUnblock
    case cardDisable
    case trustedDeviceInfo = "trustedDeviceInfo"
    case checkFinalFee = "checkFinalFee"
    case confirmationTransfer = "confirmationTransfer"
    case challenge = "challenge"
    case checkTransaction = "checkTransaction"
    case notifiyDevice = "notifyDevice"
    case operationsProducts = "operationsProducts"
    case activeContext = "activeContext"
    case loginInfo = "loginInfo"
    case getReceipt = "getReceipt"
    case expensesChart = "expensesChart"
    case fundDetail = "fundDetail"
    case fundTransactions = "fundTransactions"
    case applePayConfirmation = "applePayConfirmation"
    case notificationPushqueryUnreadedCount = "notificationPushqueryUnreadedCount"
    case notificationPushqueryList = "notificationPushqueryList"
    case exchangeRates = "exchangeRates"
    case notificationPushDetailsBeforeLogin = "notificationPushDetailsBeforeLogin"
    case notificationPushStatusBeforeLogin = "notificationPushStatusBeforeLogin"
    case getExternalPopular = "getExternalPopular"
    case quickBalance = "quickBalance"
    case confirmQuickBalance = "confirmQuickBalance"
    case quickBalanceSettings = "quickBalanceSettings"
    case getTopUpAccounts = "getTopUpAccounts"
    case getOperators = "getOperators"
    case getGsmOperators = "getGsmOperators"
    case getInternetContacts = "getInternetContacts"
    case getTopUpAccount = "getTopUpAccount"
    case activeEwallets = "activeEwallets"
    case getTrnToConf = "getTrnToConf"
    case pspTicket = "pspTicket"
    case verifyContacts = "verifyContacts"
    case p2pAlias = "p2pAlias"
    case accountForDebit = "accountForDebit"
    case acceptTransfer = "acceptTransfer"
    case accountOwnerDetail
}
