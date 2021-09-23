//
//  PTManagersProvider.swift
//  SanPLLibrary

import Foundation

public protocol PLManagersProviderProtocol {
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol
    func getLoginManager() -> PLLoginManagerProtocol
    func getTrustedDeviceManager() -> PLTrustedDeviceManager
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol
    func getAccountsManager() -> PLAccountManagerProtocol
    func getCardsManager() -> PLCardsManagerProtocol
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol
    func getCustomerManager() -> PLCustomerManagerProtocol
}

public final class PLManagersProvider {
    private let environmentsManager: PLEnvironmentsManager
    private let loginManager: PLLoginManager
    private let trustedDeviceManager: PLTrustedDeviceManager
    private let globalPositionManager: PLGlobalPositionManagerProtocol
    private let accountManager: PLAccountManager
    private let cardsManager: PLCardsManager
    private let cardTransactionsManager: PLCardTransactionsManager
    private let loansManager: PLLoanManager
    private let customerManager: PLCustomerManager

    public init(bsanDataProvider: BSANDataProvider,
                hostProvider: PLHostProviderProtocol,
                networkProvider: NetworkProvider,
                demoInterpreter: DemoUserProtocol) {
        self.environmentsManager = PLEnvironmentsManager(bsanDataProvider: bsanDataProvider, hostProvider: hostProvider)
        self.loginManager = PLLoginManager(bsanDataProvider: bsanDataProvider,
                                           networkProvider: networkProvider,
                                           demoInterpreter: demoInterpreter)
        self.trustedDeviceManager = PLTrustedDeviceManager(bsanDataProvider: bsanDataProvider,
                                                           networkProvider: networkProvider,
                                                           demoInterpreter: demoInterpreter)
        self.globalPositionManager = PLGlobalPositionManager(bsanDataProvider: bsanDataProvider,
                                                             networkProvider: networkProvider,
                                                             demoInterpreter: demoInterpreter)
        self.cardsManager = PLCardsManager(bsanDataProvider: bsanDataProvider)
        self.cardTransactionsManager = PLCardTransactionsManager(dataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.accountManager = PLAccountManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.loansManager = PLLoanManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.customerManager = PLCustomerManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
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
}
