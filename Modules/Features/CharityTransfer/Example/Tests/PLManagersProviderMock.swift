import SANPLLibrary
import Commons

final class PLManagersProviderMock: PLManagersProviderProtocol {
  
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        fatalError()
    }
    
    func getAccountsManager() -> PLAccountManagerProtocol {
        fatalError()
    }

    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        fatalError()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        dependenciesResolver.resolve(for: PLLoginManagerProtocol.self)
    }
    
    func getBLIKManager() -> PLBLIKManagerProtocol {
        fatalError()
    }
    
    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        fatalError()
    }
    
    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        fatalError()
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        fatalError()
    }
    
    func getCardsManager() -> PLCardsManagerProtocol {
        fatalError()
    }
    
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError()
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        fatalError()
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        fatalError()
    }
    
    func getNotificationManager() -> PLNotificationManagerProtocol {
        fatalError()
    }
    
    func getTransferManager() -> PLTransfersManagerProtocol {
        dependenciesResolver.resolve(for: PLTransfersManagerProtocol.self)
    }
}
