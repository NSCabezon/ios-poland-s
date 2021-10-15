//
//  PTManagersProvider.swift
//  SanPLLibrary

import Foundation

public protocol PLManagersProviderProtocol {
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol
    func getLoginManager() -> PLLoginManagerProtocol
    func getBLIKManager() -> PLBLIKManagerProtocol
    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol
    func getTrustedDeviceManager() -> PLTrustedDeviceManager
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol
    func getAccountsManager() -> PLAccountManagerProtocol
    func getCardsManager() -> PLCardsManagerProtocol
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol
    func getCustomerManager() -> PLCustomerManagerProtocol
    func getNotificationManager() -> PLNotificationManagerProtocol
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol
    func getTransferManager() -> PLTransfersManagerProtocol
}

public final class PLManagersProvider {
    private let environmentsManager: PLEnvironmentsManager
    private let loginManager: PLLoginManager
    private let blikManager: PLBLIKManagerProtocol
    private let creditCardRepaymentManager: PLCreditCardRepaymentManagerProtocol
    private let helpCenterManager: PLHelpCenterManagerProtocol
    private let trustedDeviceManager: PLTrustedDeviceManager
    private let globalPositionManager: PLGlobalPositionManagerProtocol
    private let accountManager: PLAccountManager
    private let cardsManager: PLCardsManager
    private let cardTransactionsManager: PLCardTransactionsManager
    private let loansManager: PLLoanManager
    private let customerManager: PLCustomerManager
    private let notificationManager: PLNotificationManager
    private let loanScheduleManager: PLLoanScheduleManager
    private let transferManger: PLTransfersManager

    public init(bsanDataProvider: BSANDataProvider,
                hostProvider: PLHostProviderProtocol,
                networkProvider: NetworkProvider,
                demoInterpreter: DemoUserProtocol) {
        self.environmentsManager = PLEnvironmentsManager(bsanDataProvider: bsanDataProvider, hostProvider: hostProvider)
        self.loginManager = PLLoginManager(bsanDataProvider: bsanDataProvider,
                                           networkProvider: networkProvider,
                                           demoInterpreter: demoInterpreter)
        self.blikManager = PLBLIKManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.creditCardRepaymentManager = PLCreditCardRepaymentManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.helpCenterManager = PLHelpCenterManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.trustedDeviceManager = PLTrustedDeviceManager(bsanDataProvider: bsanDataProvider,
                                                           networkProvider: networkProvider,
                                                           demoInterpreter: demoInterpreter)
        self.globalPositionManager = PLGlobalPositionManager(bsanDataProvider: bsanDataProvider,
                                                             networkProvider: networkProvider,
                                                             demoInterpreter: demoInterpreter)
        self.cardsManager = PLCardsManager(bsanDataProvider: bsanDataProvider,
                                           networkProvider: networkProvider)
        self.cardTransactionsManager = PLCardTransactionsManager(dataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.accountManager = PLAccountManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.loansManager = PLLoanManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.customerManager = PLCustomerManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.notificationManager = PLNotificationManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.loanScheduleManager = PLLoanScheduleManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.transferManger = PLTransfersManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
    }
}

// MARK: - PTManagersProviderProtocol

extension PLManagersProvider: PLManagersProviderProtocol {

    public func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        return self.environmentsManager
    }

    public func getLoginManager() -> PLLoginManagerProtocol {
        return self.loginManager
    }

    public func getBLIKManager() -> PLBLIKManagerProtocol {
        return self.blikManager
    }

    public func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        return self.creditCardRepaymentManager
    }
    
    public func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        return self.helpCenterManager
    }

    public func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        return self.trustedDeviceManager
    }
    
    public func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        return globalPositionManager
    }

    public func getAccountsManager() -> PLAccountManagerProtocol {
        self.accountManager
    }

    public func getCardsManager() -> PLCardsManagerProtocol {
        return self.cardsManager
    }

    public func getLoansManager() -> PLLoanManagerProtocol {
        return self.loansManager
    }

    public func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        self.cardTransactionsManager
    }
    
    public func getCustomerManager() -> PLCustomerManagerProtocol {
        self.customerManager
    }

    public func getNotificationManager() -> PLNotificationManagerProtocol {
        self.notificationManager
    }
    
    public func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        self.loanScheduleManager
    }
    
    public func getTransferManager() -> PLTransfersManagerProtocol {
        self.transferManger
    }
}
