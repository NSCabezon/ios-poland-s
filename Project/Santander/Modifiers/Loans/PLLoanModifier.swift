//
//  PLLoanModifier.swift
//  Santander
//
//  Created by Francisco Perez Martinez on 20/7/21.
//

import Loans
import UI
import Commons
import Models
import SANPLLibrary


final class PLLoanModifier {
    private let managersProvider: PLManagersProviderProtocol
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let loanScheduleButton: LoansHomeOption
    private let customerServiceButton: LoansHomeOption

    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.managersProvider = dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
        self.dependenciesEngine = dependenciesEngine
        self.loanScheduleButton = .custom(title: "loansOption_button_loanSchedule", imageName: "icnLoanSchedule", accessibilityIdentifier: "loansOption_button_loanSchedule")
        self.customerServiceButton = .custom(title: "loansOption_button_customerService", imageName: "icnCustomerService", accessibilityIdentifier: "loansOption_button_customerService")
    }
}

extension PLLoanModifier: LoansModifierProtocol {
    var enabledLoanOptions: Bool {
        return false
    }

    var waitForLoanDetail: Bool {
        return false
    }

    var sortByMostRecent: Bool {
        return false
    }

    func getLoansOptions(for loan: LoanEntity?, with loanDetail: LoanDetailEntity?) -> [LoansHomeOption]? {
        return [self.loanScheduleButton, self.customerServiceButton, .loanDetail]
    }

    func didSelectLoanOption(_ option: LoansHomeOption) {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}