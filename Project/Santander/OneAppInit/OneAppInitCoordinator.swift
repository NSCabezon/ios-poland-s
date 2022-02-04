//
//  OneAppInitCoordinator.swift
//  Santander
//
//  Created by 186489 on 07/06/2021.
//

import Foundation
import Commons
import BLIK
import TaxTransfer
import CreditCardRepayment
import PLHelpCenter
import DemoAuthenticator
import LoanSchedule
import mCommerce
import PLNotificationsInbox
import UI
import PLCommons
import PLCommonOperatives
import PLUI
import CharityTransfer
import CoreFoundationLib
import SANLegacyLibrary
import PhoneTopUp
import ZusTransfer

enum OneAppInitModule: String, CaseIterable {
    case deepLink = "Deep Link"
    case blik = "BLIK"
    case creditCardRepaymentMock = "Credit Card Repayment [MOCK]"
    case creditCardRepaymentMultipleChoicesMock = "Credit Card Repayment Multiple Choices [MOCK]"
    case creditCardRepaymentStartWithPredefinedAccountNumber = "Credit Card Repayment Predefined Account Number [MOCK]"
    case creditCardRepayment = "Credit Card Repayment"
    case helpCenter = "Help Center"
    case loanSchedule = "Loan Schedule"
    case mCommerce = "mCommerce"
    case notificationsInbox = "Notifications Inbox"
    case charityTransfer = "Charity transfer"
    case phoneTopUp = "Phone Top-Up"
    case taxTransfer = "Tax Transfer"
    case zusTransfer = "Zus Transfer"
}

extension OneAppInitModule {
    var isMocked: Bool {
        self.rawValue.contains("[MOCK]")
    }
}

protocol OneAppInitCoordinatorProtocol: ModuleCoordinator {
    func startWithoutMocks()
    func create(with authToken: AuthToken?) -> UIViewController
}

protocol OneAppInitCoordinatorDelegate: AnyObject {
    func selectModule(_ module: OneAppInitModule)
    func selectCharityTransfer(accounts: [AccountForDebit])
    func selectZusTransfer(accounts: [AccountForDebit])
}

final class OneAppInitCoordinator: OneAppInitCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    var view: OneAppInitViewController?
    
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private var authToken: AuthToken?
    
    private lazy var mockInjector = CreditCardRepaymentMockInjector(dependenciesEngine: dependenciesEngine)
    
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector, navigationController: UINavigationController?) {
        self.dependenciesEngine = dependenciesEngine
        self.navigationController = navigationController
    }
    
    func start() {
        start(withModules: OneAppInitModule.allCases)
    }
    
    func startWithoutMocks() {
        let modules = OneAppInitModule.allCases.filter { !$0.isMocked }
        start(withModules: modules)
    }
    
    private func start(withModules modules: [OneAppInitModule]) {
        let viewController = OneAppInitViewController(dependencyResolver: dependenciesEngine, modules: modules, delegate: self)
        self.view = viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func create(with authToken: AuthToken?) -> UIViewController {
        self.authToken = authToken
        
        if let accessToken = authToken?.accessToken {
            UserDefaults.standard.setValue(accessToken, forKey: "pl-temporary-simple-accessToken")
            FakeLoginTokenInjector.injectToken(dependenciesEngine: dependenciesEngine)
        }
        
        return OneAppInitViewController(dependencyResolver: dependenciesEngine, modules: OneAppInitModule.allCases, delegate: self)
    }
}

extension OneAppInitCoordinator: OneAppInitCoordinatorDelegate {
    func selectModule(_ module: OneAppInitModule) {
        switch module {
        case .deepLink:
            let coordinator = DeepLinkDebugLauncherMenuCoordinator(
                dependenciesEngine: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .blik:
            let coordinator = BLIKHomeCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .creditCardRepaymentMock:
            mockInjector.injectMockForCreditCardRepayment(multipleChoices: false)
            let coordinator = CreditCardRepaymentModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .creditCardRepaymentMultipleChoicesMock:
            let coordinator = CreditCardRepaymentModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            mockInjector.injectMockForCreditCardRepayment(multipleChoices: true)
            coordinator.start()
        case .creditCardRepaymentStartWithPredefinedAccountNumber:
            let coordinator = CreditCardRepaymentModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            mockInjector.injectMockForCreditCardRepayment(multipleChoices: true)
            var cardDTO = SANLegacyLibrary.CardDTO()
            cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: "545250P038230083")
            coordinator.start(with: CardEntity(cardDTO))
        case .creditCardRepayment:
            let coordinator = CreditCardRepaymentModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .helpCenter:
            let coordinator = PLHelpCenterModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .loanSchedule:
            let coordinator = LoanScheduleModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start(
                with: LoanScheduleIdentity(
                    loanAccountNumber: "1234",
                    loanName: "Kredyt Hipoteczny"
                )
            )
        case .mCommerce:
            let coordinator = mCommerceModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .notificationsInbox:
            let coordinator = PLNotificationsInboxModuleCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .taxTransfer:
            let coordinator = TaxTransferFormCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController
            )
            coordinator.start()
        case .phoneTopUp:
            let coordinator = TopUpDataLoaderCoordinator(dependenciesResolver: dependenciesEngine,
                                                         navigationController: navigationController)
            coordinator.start()
        default:
            break
        }
    }
    
    func selectCharityTransfer(accounts: [AccountForDebit]) {
        guard !accounts.isEmpty else {
            view?.showError()
            return
        }
        let repository = dependenciesEngine.resolve(for: PLTransferSettingsRepository.self)
        let settings = repository.get()?.charityTransfer
        let charityTransferSettings = CharityTransferSettings(transferRecipientName: settings?.transferRecipientName,
                                                              transferAccountNumber: settings?.transferAccountNumber,
                                                              transferTitle: settings?.transferTitle)
        let coordinator: CharityTransferModuleCoordinator = dependenciesEngine.resolve()
        coordinator.setProperties(accounts: accounts,
                                  charityTransferSettings: charityTransferSettings)
        coordinator.start()
    }
   
    func selectZusTransfer(accounts: [AccountForDebit]) {
        guard !accounts.isEmpty else {
            view?.showError()
            return
        }
        let coordinator = ZusTransferModuleCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts
        )
        coordinator.start()
    }
}
