//
//  PTManagersProvider.swift
//  SanPLLibrary

import Foundation

public protocol PLManagersProviderProtocol {
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol
    func getLoginManager() -> PLLoginManagerProtocol
    func getTrustedDeviceManager() -> PLTrustedDeviceManager
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol
//    func getAccountsManager() -> PTAccountsManagerProtocol
    func getCardsManager() -> PLCardsManagerProtocol
//    func getCardTransactionsManager() -> PTCardTransactionsManagerProtocol
//    func getAuthManager() -> PTAuthManagerProtocol
//    func getDepositsManager() -> PTDepositsManagerProtocol
//    func getLoansManager() -> PTLoansManagerProtocol
//    func getPensionsManager() -> PTPensionsManagerProtocol
//    func getTopUpsManager() -> PTTopUpsManagerProtocol
//    func getNewTopUpsManager() -> PTNewTopUpManagerProtocol
//    func getScheduleListManager() -> PTScheduleListManagerProtocol
//    func getPayessManager() -> PTPayeesManagerProtocol
//    func getMBWayManager() -> PTMBWayManagerProtocol
//    func getCustomersManager() -> PTCustomersManagerProtocol
//    func getTransfersManager() -> PTTransfersManagerProtocol
}

public final class PLManagersProvider {
    private let environmentsManager: PLEnvironmentsManager
    private let loginManager: PLLoginManager
    private let trustedDeviceManager: PLTrustedDeviceManager
    private let globalPositionManager: PLGlobalPositionManagerProtocol
//    private let accountManager: PTAccountsManager
    private let cardsManager: PLCardsManager
//    private let cardTransactionsManager: PTCardTransactionsManager
//    private let authManager: PTAuthManager
//    private let depositsManager: PTDepositsManager
    private let loansManager: PLLoanManager
//    private let pensionsManager: PTPensionsManager
//    private let topUpsManager: PTTopUpsManager
//    private let newTopUpsManager: PTNewTopUpManager
//    private let payeesManager: PTPayeesManager
//    private let mbwayManager: PTMBWayManager
//    private let customersManager: PTCustomersManager
//    private let transfersManager: PTTransfersManager
//    private let scheduleList: PTScheduleListManagerProtocol

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
//        self.cardTransactionsManager = PTCardTransactionsManager(dataProvider: bsanDataProvider, networkProvider: networkProvider)
//        self.accountManager = PTAccountsManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.authManager = PTAuthManager(networkProvider: networkProvider, dataProvider: bsanDataProvider)
//        self.depositsManager = PTDepositsManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
        self.loansManager = PLLoanManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
//        self.pensionsManager = PTPensionsManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.topUpsManager = PTTopUpsManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.newTopUpsManager = PTNewTopUpManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.scheduleList = PTScheduleListManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
//        self.payeesManager = PTPayeesManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.mbwayManager = PTMBWayManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.customersManager = PTCustomersManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
//        self.transfersManager = PTTransfersManager(networkProvider: networkProvider, bsanDataProvider: bsanDataProvider)
    }
}

// MARK: - PTManagersProviderProtocol

extension PLManagersProvider: PLManagersProviderProtocol {
//    public func getAuthManager() -> PTAuthManagerProtocol {
//        return self.authManager
//    }
//
//    public func getScheduleListManager() -> PTScheduleListManagerProtocol {
//        return self.scheduleList
//    }
//
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
//
//    public func getAccountsManager() -> PTAccountsManagerProtocol {
//        self.accountManager
//    }
//
    public func getCardsManager() -> PLCardsManagerProtocol {
        return self.cardsManager
    }
//

//
//    public func setEnvironment(environment: BSANPTEnvironmentDTO) {
//        _ = environmentsManager.setEnvironment(bsanEnvironment: environment)
//    }
//
//    public func getDepositsManager() -> PTDepositsManagerProtocol {
//        return self.depositsManager
//    }
//
    public func getLoansManager() -> PLLoanManagerProtocol {
        return self.loansManager
    }
//
//    public func getPensionsManager() -> PTPensionsManagerProtocol {
//        return self.pensionsManager
//    }
//
//    public func getTopUpsManager() -> PTTopUpsManagerProtocol {
//        return self.topUpsManager
//    }
//
//    public func getNewTopUpsManager() -> PTNewTopUpManagerProtocol {
//        return self.newTopUpsManager
//    }
//
//    public func getPayessManager() -> PTPayeesManagerProtocol {
//        return self.payeesManager
//    }
//
//    public func getMBWayManager() -> PTMBWayManagerProtocol {
//        return self.mbwayManager
//    }
//
//    public func getCardTransactionsManager() -> PTCardTransactionsManagerProtocol {
//        self.cardTransactionsManager
//    }
//
//    public func getCustomersManager() -> PTCustomersManagerProtocol {
//        return self.customersManager
//    }
//
//    public func getTransfersManager() -> PTTransfersManagerProtocol {
//        return self.transfersManager
//    }
}
