//
//  PLManagersProviderAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

public protocol PLManagersProviderAdapterProtocol {
    func getPLManagerProvider() -> PLManagersProviderProtocol
}

public final class PLManagersProviderAdapter {
    private let authManager: PLAuthManagerAdapter
    private let globalPositionManagerAdapter: PLGlobalPositionManagerAdapter
    private let cardsManagerAdapter: PLCardsManagerAdapter
    private let portfoliosPBManagerAdapter: PLPortfoliosPBManagerAdapter
    private let pullOffersManagerAdapter: PLPullOffersManagerAdapter
    private let scaManagerAdapter: PLScaManagerAdapter
    private let sendMoneyManagerAdapter: PLSendMoneyManagerAdapter
    private let signatureAdapter: PLSignatureAdapter
    private let userSegmentManagerAdapter: PLUserSegmentManagerAdapter
    private let depositsManagerApadater: PLDepositsManagerAdapter
    private let environmentsManagerApadater: PLEnvironmentsManagerAdapter
    private let sessionManagerApadater: PLSessionManagerAdapter
    private let insurancesManager: PLInsurancesManagerAdapter
    private let accountsManager: PLAccountsManagerAdapter
    private let managersManager: PLManagersManagerAdapter
    private let sociusManager: PLSociusManagerAdapter
    private let transfersManager: PLTransfersManagerAdapter
    private let mobileRechargeManager: PLMobileRechargeManagerAdapter
    private let stocksManager: PLStocksManagerAdapter
    private let billTaxesManager: PLBillTaxesManagerAdapter
    private let personDataManager: PLPersonDataManagerAdapter
    private let touchIdManager: PLTouchIdManagerAdapter
    private let loansManager: PLLoansManagerAdapter
    private let fundsManager: PLFundsManagerAdapter
    private let pensionsManager: PLPensionsManagerAdapter
    private let cashWithdrawalManager: PLCashWithdrawalManagerAdapter
    private let cesManager: PLCesManagerApadater
    private let mifidManager: PLMifidManagerAdapter
    private let otpPushManager: PLOTPPushManagerAdapter
    private let timeLineManager: PLTimeLineManagerAdapter
    private let simulatorManager: PLLoanSimulatorManagerAdapter
    private let onePlanManager: PLOnePlanManagerAdapter
    private let lastLogonManager: PLLastLogonManagerAdapter
    private let financialAgregatorManager: PLFinancialAgregatorManagerAdapter
    private let bizumManager: PLBizumManagerAdapter
    private let managerNotificationsManager: PLManagerNotificationsManagerAdapter
    private let recoveryNoticesManager: PLRecoveryNoticesManagerAdapter
    private let favouriteTransfersManager: PLFavouriteTransfersManagerAdapter
    private let aviosManager: PLAviosManagerAdapter
    private let branchLocatorManager: PLBranchLocatorManagerAdapter
    private let pendingSolicitudesManager: PLPendingSolicitudesManagerAdapter
    private let plManagersProvider: PLManagersProvider
    private let demoInterpreter: DemoUserProtocol
    private let ecommerceManagerAdapter: PLEcommerceManagerAdapter
    private let predefineSCAManager: PLPredefineSCAManagerAdapter
    private let fintechManager: PLFintechManagerAdapter

    public init(bsanDataProvider:SANPLLibrary.BSANDataProvider,
                hostProvider: PLHostProviderProtocol,
                networkProvider: NetworkProvider,
                demoInterpreter: DemoUserProtocol) {
        self.pullOffersManagerAdapter = PLPullOffersManagerAdapter()
        self.scaManagerAdapter = PLScaManagerAdapter()
        self.environmentsManagerApadater = PLEnvironmentsManagerAdapter(bsanHostProvider: hostProvider,
                                                                        dataProvider: bsanDataProvider)
        self.plManagersProvider = PLManagersProvider(bsanDataProvider: bsanDataProvider,
                                                    hostProvider: hostProvider,
                                                    networkProvider: networkProvider,
                                                    demoInterpreter: demoInterpreter)
        self.insurancesManager = PLInsurancesManagerAdapter()
        self.managersManager = PLManagersManagerAdapter()
        self.sociusManager = PLSociusManagerAdapter()
        self.mobileRechargeManager = PLMobileRechargeManagerAdapter()
        self.stocksManager = PLStocksManagerAdapter()
        self.billTaxesManager = PLBillTaxesManagerAdapter()
        self.personDataManager = PLPersonDataManagerAdapter()
        self.touchIdManager = PLTouchIdManagerAdapter()
        self.fundsManager = PLFundsManagerAdapter()
        self.cashWithdrawalManager = PLCashWithdrawalManagerAdapter()
        self.cesManager = PLCesManagerApadater()
        self.mifidManager = PLMifidManagerAdapter()
        self.otpPushManager = PLOTPPushManagerAdapter()
        self.timeLineManager = PLTimeLineManagerAdapter()
        self.simulatorManager = PLLoanSimulatorManagerAdapter()
        self.onePlanManager = PLOnePlanManagerAdapter()
        self.lastLogonManager = PLLastLogonManagerAdapter()
        self.financialAgregatorManager = PLFinancialAgregatorManagerAdapter()
        self.bizumManager = PLBizumManagerAdapter()
        self.managerNotificationsManager = PLManagerNotificationsManagerAdapter()
        self.recoveryNoticesManager = PLRecoveryNoticesManagerAdapter()
        self.aviosManager = PLAviosManagerAdapter()
        self.branchLocatorManager = PLBranchLocatorManagerAdapter()
        self.pendingSolicitudesManager = PLPendingSolicitudesManagerAdapter()
        self.userSegmentManagerAdapter = PLUserSegmentManagerAdapter()
        self.demoInterpreter = demoInterpreter
        self.portfoliosPBManagerAdapter = PLPortfoliosPBManagerAdapter()
        self.globalPositionManagerAdapter = PLGlobalPositionManagerAdapter(globalPositionManager: self.plManagersProvider.getGlobalPositionManager(), bsanDataProvider: bsanDataProvider)
        self.transfersManager = PLTransfersManagerAdapter()
        self.accountsManager = PLAccountsManagerAdapter()
        self.cardsManagerAdapter = PLCardsManagerAdapter(cardsManager: self.plManagersProvider.getCardsManager())
        self.signatureAdapter = PLSignatureAdapter()
        self.depositsManagerApadater = PLDepositsManagerAdapter()
        self.loansManager = PLLoansManagerAdapter()
        self.pensionsManager = PLPensionsManagerAdapter()
        self.favouriteTransfersManager = PLFavouriteTransfersManagerAdapter()
        self.sessionManagerApadater = PLSessionManagerAdapter()
        self.authManager = PLAuthManagerAdapter()
        self.sendMoneyManagerAdapter = PLSendMoneyManagerAdapter()
        self.ecommerceManagerAdapter = PLEcommerceManagerAdapter()
        self.predefineSCAManager = PLPredefineSCAManagerAdapter()
        self.fintechManager = PLFintechManagerAdapter()
    }
}

extension PLManagersProviderAdapter: BSANManagersProvider {

    public func getBsanAuthManager() -> BSANAuthManager {
        return self.authManager
    }
    
    public func getBsanPGManager() -> BSANPGManager {
        return self.globalPositionManagerAdapter
    }
    
    public func getBsanDepositsManager() -> BSANDepositsManager {
        return self.depositsManagerApadater
    }
    
    public func getBsanEnvironmentsManager() -> SANLegacyLibrary.BSANEnvironmentsManager {
        return self.environmentsManagerApadater
    }
    
    public func getBsanSessionManager() -> BSANSessionManager {
        return self.sessionManagerApadater
    }
    
    public func getBsanInsurancesManager() -> BSANInsurancesManager {
        return self.insurancesManager
    }
    
    public func getBsanCardsManager() -> SANLegacyLibrary.BSANCardsManager {
        return self.cardsManagerAdapter
    }
    
    public func getBsanUserSegmentManager() -> BSANUserSegmentManager {
        return self.userSegmentManagerAdapter
    }
    
    public func getBsanPortfoliosPBManager() -> BSANPortfoliosPBManager {
        return self.portfoliosPBManagerAdapter
    }
    
    public func getBsanAccountsManager() -> BSANAccountsManager {
        return self.accountsManager
    }
    
    public func getBsanManagersManager() -> BSANManagersManager {
        return self.managersManager
    }
    
    public func getBsanSociusManager() -> BSANSociusManager {
        return self.sociusManager
    }
    
    public func getBsanTransfersManager() -> BSANTransfersManager {
        return self.transfersManager
    }
    
    public func getBsanSendMoneyManager() -> BSANSendMoneyManager {
        return self.sendMoneyManagerAdapter
    }
    
    public func getBsanMobileRechargeManager() -> BSANMobileRechargeManager {
        return self.mobileRechargeManager
    }
    
    public func getBsanStocksManager() -> BSANStocksManager {
        return self.stocksManager
    }
    
    public func getBsanPullOffersManager() -> BSANPullOffersManager {
        return self.pullOffersManagerAdapter
    }
    
    public func getBsanBillTaxesManager() -> BSANBillTaxesManager {
        return self.billTaxesManager
    }
    
    public func getBsanSignatureManager() -> SANLegacyLibrary.BSANSignatureManager {
        return self.signatureAdapter
    }
    
    public func getBsanPersonDataManager() -> BSANPersonDataManager {
        return self.personDataManager
    }
    
    public func getBsanTouchIdManager() -> BSANTouchIdManager {
        return self.touchIdManager
    }
    
    public func getBsanLoansManager() -> BSANLoansManager {
        return self.loansManager
    }
    
    public func getBsanFundsManager() -> BSANFundsManager {
        return self.fundsManager
    }
    
    public func getBsanPensionsManager() -> BSANPensionsManager {
        return self.pensionsManager
    }
    
    public func getBsanCashWithdrawalManager() -> BSANCashWithdrawalManager {
        return self.cashWithdrawalManager
    }
    
    public func getBsanCesManager() -> BSANCesManager {
        return self.cesManager
    }
    
    public func getBsanMifidManager() -> BSANMifidManager {
        return self.mifidManager
    }
    
    public func getBsanOTPPushManager() -> BSANOTPPushManager {
        return self.otpPushManager
    }
    
    public func getBsanScaManager() -> BSANScaManager {
        return self.scaManagerAdapter
    }
    
    public func getTimeLineMovementsManager() -> BSANTimeLineManager {
        return self.timeLineManager
    }
    
    public func getBSANLoanSimulatorManager() -> BSANLoanSimulatorManager {
        return self.simulatorManager
    }
    
    public func getBsanOnePlanManager() -> BSANOnePlanManager {
        return self.onePlanManager
    }
    
    public func getLastLogonManager() -> BSANLastLogonManager {
        return self.lastLogonManager
    }
    
    public func getFinancialAgregatorManager() -> BSANFinancialAgregatorManager {
        return self.financialAgregatorManager
    }
    
    public func getBSANBizumManager() -> BSANBizumManager {
        return self.bizumManager
    }
    
    public func getManagerNotificationsManager() -> BSANManagerNotificationsManager {
        return self.managerNotificationsManager
    }
    
    public func getRecoveryNoticesManager() -> BSANRecoveryNoticesManager {
        return self.recoveryNoticesManager
    }
    
    public func getBsanFavouriteTransfersManager() -> BSANFavouriteTransfersManager {
        return self.favouriteTransfersManager
    }
    
    public func getBsanAviosManager() -> BSANAviosManager {
        return self.aviosManager
    }
    
    public func getBsanBranchLocatorManager() -> BSANBranchLocatorManager {
        return self.branchLocatorManager
    }
    
    public func getBsanPendingSolicitudesManager() -> BSANPendingSolicitudesManager {
        return self.pendingSolicitudesManager
    }
    
    public func getBsanEcommerceManager() -> BSANEcommerceManager {
        return self.ecommerceManagerAdapter
    }

    public func getBsanPredefineSCAManager() -> BSANPredefineSCAManager {
        return self.predefineSCAManager
    }
    public func getBsanFintechManager() -> BSANFintechManager {
        return self.fintechManager
    }
}

extension PLManagersProviderAdapter: PLManagersProviderAdapterProtocol {
    public func getPLManagerProvider() -> PLManagersProviderProtocol {
        return self.plManagersProvider
    }
}
