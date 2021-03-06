//
//  OneAppInitCoordinator.swift
//  Santander
//
//  Created by 186489 on 07/06/2021.
//

import Foundation
import CoreFoundationLib
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
import SANLegacyLibrary
import PhoneTopUp
import ZusTransfer
import ZusSMETransfer
import SplitPayment
import ScanAndPay
import Authorization

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
    case authorization = "Authorization"
    case zusSMETransfer = "Zus SME Transfer"
    case splitPayment = "Split Payment"
    case scanAndPay = "Scan and Pay"
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
            let repository = dependenciesEngine.resolve(for: PLTransferSettingsRepository.self)
            let settingsDto = repository.get()?.topup ?? []
            let topUpSettings = settingsDto
                .compactMap({ TopUpOperatorSettings(operatorId: $0.id, defaultTopUpValue: $0.defValue, requestAcceptance: $0.reqAcceptance) })
            let coordinator = TopUpDataLoaderCoordinator(dependenciesResolver: dependenciesEngine,
                                                         navigationController: navigationController,
                                                         settings: topUpSettings)
            coordinator.start()
        case .zusTransfer:
            let coordinator = dependenciesEngine.resolve(
                for: ZusTransferModuleCoordinatorProtocol.self
            )
            coordinator.start()
        case .authorization:
            let coordinator = dependenciesEngine.resolve(
                for: AuthorizationModuleCoordinator.self
            )
            coordinator.start()
        case .charityTransfer:
            let coordinator = dependenciesEngine.resolve(
                for: CharityTransferModuleCoordinator.self
            )
            coordinator.start()
        case .zusSMETransfer:
            let coordinator = dependenciesEngine.resolve(
                for: ZusSmeTransferDataLoaderCoordinatorProtocol.self
            )
            coordinator.start()
        case .splitPayment:
            let coordinator = dependenciesEngine.resolve(
                for: SplitPaymentModuleCoordinatorProtocol.self
            )
            coordinator.start()
        case .scanAndPay:
            let coordinator = ScanAndPayScannerCoordinator(dependenciesResolver: dependenciesEngine,
                                                           navigationController: navigationController)
            coordinator.start()
        default:
            break
        }
    }
}
