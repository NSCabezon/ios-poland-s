//
//  OneAppInitCoordinator.swift
//  Santander
//
//  Created by 186489 on 07/06/2021.
//

import Foundation
import Commons
import BLIK
import CreditCardRepayment
import PLHelpCenter
import DemoAuthenticator
import LoanSchedule
import mCommerce
import PLNotificationsInbox
import UI
import PLCommons
import PLUI
import CharityTransfer

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
            coordinator.start(with: CreditCardAccountNumber(number: "63109014894000000121600961"))
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
        default:
            break
        }
    }
    
    func selectCharityTransfer(accounts: [AccountForDebit]) {
        let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        let models = accounts.compactMap({ try? mapper.map($0) })
        guard !models.isEmpty else {
            view?.showError()
            return
        }
        if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
            let coordinator = CharityTransferFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                             navigationController: navigationController,
                                                             accounts: models)
            coordinator.start()
        } else {
            do {
                let viewModels = try accounts.map({ try mapper.map($0) })
                let coordinator = AccountSelectorCoordinator(dependenciesResolver: dependenciesEngine,
                                                             navigationController: navigationController,
                                                             viewModels: viewModels,
                                                             sourceView: .sendMoney)
                coordinator.start()
            } catch {
                view?.showError()
            }
        }
    }
}
