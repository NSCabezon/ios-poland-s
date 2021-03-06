//
//  PTManagersProvider.swift
//  SanPLLibrary

import Foundation
import OpenCombine

/// Note: Please add also extension method (at the bottom) that returns fatal error when adding new Manager
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
	func getLoansManager() -> PLLoanManagerProtocol
	func getDepositsManager() -> PLDepositManagerProtocol
	func getFundsManager() -> PLFundManagerProtocol
    func getSavingManager() -> PLSavingManagerProtocol
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol
    func getCustomerManager() -> PLCustomerManagerProtocol
    func getNotificationManager() -> PLNotificationManagerProtocol
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol
    func getTransferManager() -> PLTransfersManagerProtocol
    func getCardOperativesManager() -> PLCardOperativesManagerProtocol
    func getAuthorizationProcessorManager() -> PLAuthorizationProcessorManagerProtocol
    func getPhoneTopUpManager() -> PLPhoneTopUpManagerProtocol
    func getOperationsProductsManager() -> PLOperationsProductsManagerProtocol
    func getTaxTransferManager() -> PLTaxTransferManagerProtocol
    func getHistoryManager() -> PLHistoryManagerProtocol
    func getExpensesChartManager() -> PLExpensesChartManagerProtocol
    func getSplitPaymentManager() -> PLSplitPaymentManagerProtocol
    func getQuickBalanceManager() -> PLQuickBalanceManagerProtocol
}

public protocol PLManagersProviderReactiveProtocol {
    func getHistoryManager() -> AnyPublisher<PLHistoryManagerProtocol, Never>
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
    private let savingManager: PLSavingManager
    private let cardsManager: PLCardsManager
    private let cardTransactionsManager: PLCardTransactionsManager
	private let loansManager: PLLoanManager
	private let depositsManager: PLDepositManager
	private let fundsManager: PLFundManager
    private let customerManager: PLCustomerManager
    private let notificationManager: PLNotificationManager
    private let transferManager: PLTransfersManager
    private let cardOperativesManager: PLCardOperativesManager
    private let loanScheduleManager: PLLoanScheduleManager
    private let authorizationProcessorManager: PLAuthorizationProcessorManager
    private let phoneTopUpManager: PLPhoneTopUpManagerProtocol
    private let operationsProductsManager: PLOperationsProductsManagerProtocol
    private let taxTransferManager: PLTaxTransferManagerProtocol
    private let historyManager: PLHistoryManagerProtocol
    private let expensesChartManager: PLExpensesChartManagerProtocol
    private let splitPaymentManager: PLSplitPaymentManagerProtocol
    private let quickBalanceManager: PLQuickBalanceManagerProtocol
    

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
        self.savingManager = PLSavingManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.loansManager = PLLoanManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
		self.depositsManager = PLDepositManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
		self.fundsManager = PLFundManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.customerManager = PLCustomerManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.notificationManager = PLNotificationManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.transferManager = PLTransfersManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.cardOperativesManager = PLCardOperativesManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.loanScheduleManager = PLLoanScheduleManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.authorizationProcessorManager = PLAuthorizationProcessorManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.phoneTopUpManager = PLPhoneTopUpManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.operationsProductsManager = PLOperationsProductsManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.taxTransferManager = PLTaxTransferManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider)
        self.historyManager = PLHistoryManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.expensesChartManager = PLExpensesChartManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
        self.splitPaymentManager = PLSplitPaymentManager(bsanDataProvider: bsanDataProvider,
                                                         networkProvider: networkProvider)
        self.quickBalanceManager = PLQuickBalanceManager(bsanDataProvider: bsanDataProvider, networkProvider: networkProvider, demoInterpreter: demoInterpreter)
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
    
    public func getSavingManager() -> PLSavingManagerProtocol{
        self.savingManager
    }

    public func getCardsManager() -> PLCardsManagerProtocol {
        return self.cardsManager
    }

    public func getLoansManager() -> PLLoanManagerProtocol {
        return self.loansManager
    }
	
	public func getDepositsManager() -> PLDepositManagerProtocol {
		self.depositsManager
	}
	
	public func getFundsManager() -> PLFundManagerProtocol {
		self.fundsManager
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
        self.transferManager
    }

    public func getCardOperativesManager() -> PLCardOperativesManagerProtocol {
        self.cardOperativesManager
    }
    
    public func getAuthorizationProcessorManager() -> PLAuthorizationProcessorManagerProtocol {
        self.authorizationProcessorManager
    }
    
    public func getPhoneTopUpManager() -> PLPhoneTopUpManagerProtocol {
        self.phoneTopUpManager
    }

    public func getOperationsProductsManager() -> PLOperationsProductsManagerProtocol {
        self.operationsProductsManager
    }
    
    public func getTaxTransferManager() -> PLTaxTransferManagerProtocol {
        self.taxTransferManager
    }
    
    public func getHistoryManager() -> PLHistoryManagerProtocol {
        self.historyManager
    }

    public func getExpensesChartManager() -> PLExpensesChartManagerProtocol {
        self.expensesChartManager
    }
    
    public func getSplitPaymentManager() -> PLSplitPaymentManagerProtocol {
        self.splitPaymentManager
    }

    public func getQuickBalanceManager() -> PLQuickBalanceManagerProtocol {
        self.quickBalanceManager
    }

}

public extension PLManagersProviderProtocol {

    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getLoginManager() -> PLLoginManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getBLIKManager() -> PLBLIKManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        fatalError("Missing manager implementation")
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getAccountsManager() -> PLAccountManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getCardsManager() -> PLCardsManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getLoansManager() -> PLLoanManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        fatalError("Missing manager implementation")
    }

    func getNotificationManager() -> PLNotificationManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getTransferManager() -> PLTransfersManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getCardOperativesManager() -> PLCardOperativesManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getAuthorizationProcessorManager() -> PLAuthorizationProcessorManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getTaxTransferManager() -> PLTaxTransferManagerProtocol {
        fatalError("Missing manager implementation")
    }
    
    func getOperationsProductsManager() -> PLOperationsProductsManagerProtocol {
        fatalError("Missing manager implementation")
    }
     
    func getQuickBalanceLastTransactionManager() -> PLQuickBalanceManagerProtocol {
        fatalError("Missing manager implementation")
    }
}

extension PLManagersProvider: PLManagersProviderReactiveProtocol {
    public func getHistoryManager() -> AnyPublisher<PLHistoryManagerProtocol, Never> {
        return Just(historyManager).eraseToAnyPublisher()
    }
}
