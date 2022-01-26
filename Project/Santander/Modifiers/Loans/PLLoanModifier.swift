//
//  PLLoanModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 20/7/21.
//

import Loans
import UI
import Commons
import CoreFoundationLib
import SANPLLibrary
import LoanSchedule
import Account

final class PLLoanModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let loanScheduleButton: LoansHomeOption
    private let customerServiceButton: LoansHomeOption

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
        self.loanScheduleButton = .custom(title: "loansOption_button_loanSchedule", imageName: "icnLoanSchedule", accessibilityIdentifier: AccessibilityLoansHome.loansBtnLoanSchedule.rawValue)
        self.customerServiceButton = .custom(title: "loansOption_button_customerService", imageName: "icnCustomerService", accessibilityIdentifier: AccessibilityLoansHome.loansBtnCustomerService.rawValue)
    }
}

extension PLLoanModifier: LoansModifierProtocol {
    
    func formatLoanId(_ loanId: String) -> String {
        // Introduce loan id formatting if necessary
        return loanId
    }
    
    var hideFilterButton: Bool {
        return false
    }
    
    var enabledLoanTransactionDetail: Bool {
        return true
    }
    
    var useLegacyTransactionDetailStyle: Bool {
        return false
    }
    
    var enabledLoanOptions: Bool {
        return true
    }

    var waitForLoanDetail: Bool {
        return false
    }

    var transactionsSortType: LoanTransactionsSortType {
        return .byMostRecent
    }

    func getLoansOptions(for loan: LoanEntity?, with loanDetail: LoanDetailEntity?) -> [LoansHomeOption]? {
        return [self.loanScheduleButton, self.customerServiceButton, .loanDetail]
    }

    func didSelectLoanOption(_ option: LoansHomeOption, loan: LoanEntity?) {
        if option == .custom(title: "loansOption_button_customerService", imageName: "icnCustomerService", accessibilityIdentifier: AccessibilityLoansHome.loansBtnCustomerService.rawValue) {
            didSelectCustomerService()
        } else if option == .custom(title: "loansOption_button_loanSchedule", imageName: "icnLoanSchedule", accessibilityIdentifier: AccessibilityLoansHome.loansBtnLoanSchedule.rawValue) {
            didSelectLoanSchedule(option, loan: loan)
        } else {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
    
    private func didSelectCustomerService() {
        let input: GetPLAccountOtherOperativesWebConfigurationUseCaseInput
        let repository = dependenciesEngine.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        let identifier = PLAccountOtherOperativesIdentifier.customerService.rawValue
        
        guard let list = repository.get()?.accountsOptions,
                let data = getAccountOtherOperativesEntity(list: list, identifier: identifier) else { return }
        
        input = GetPLAccountOtherOperativesWebConfigurationUseCaseInput(type: data)
        let useCase = dependenciesEngine.resolve(for: GetPLAccountOtherOperativesWebConfigurationUseCase.self)
        Scenario(useCase: useCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { result in
                self.dependenciesEngine.resolve(for: AccountsHomeCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
            }
    }
    
    private func getAccountOtherOperativesEntity(list: [PLAccountOtherOperativesDTO], identifier: String) -> PLAccountOtherOperativesData? {
        let dto = list.filter { $0.id == identifier }.first
        return PLAccountOtherOperativesData(identifier: identifier, link: dto?.url, isAvailable: dto?.isAvailable, parameter: nil)
    }
    
    private func didSelectLoanSchedule(_ option: LoansHomeOption, loan: LoanEntity?) {
        let coordinator = self.dependenciesEngine.resolve(for: LoanScheduleModuleCoordinator.self)
        let schedule = LoanScheduleIdentity(loanAccountNumber: loan?.dto.contractDescription ?? "", loanName: loan?.alias ?? "")
        coordinator.start(with: schedule)
    }

    func didSelectRepaymentLoan(_ loan: LoanEntity) {
        return
    }
}
