//
//  PLGetLoanOptionsUsecase.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/31/21.
//

import Loans
import CoreFoundationLib
import CoreDomain
import Foundation
import OpenCombine
import SANPLLibrary

struct PLGetLoanOptionsUsecase {
    let resolver: DependenciesResolver
    
    init(resolver: DependenciesResolver) {
        self.resolver = resolver
    }
}

extension PLGetLoanOptionsUsecase: GetLoanOptionsUsecase {
    func fetchOptionsPublisher() -> AnyPublisher<[LoanOptionRepresentable], Never> {
        let options = [loanScheduleButton, detail]
        return Just(options).eraseToAnyPublisher()
    }
    
    func fetchOptionsPublisher(loanDetail: LoanDetailRepresentable) -> AnyPublisher<[LoanOptionRepresentable], Never> {
        let productActionMatrix = resolver.resolve(forOptionalType: ProductActionsShortcutsMatrix.self)
        let actions = productActionMatrix?.getEnabledOperationsIdentifiers(type: .loans, contract: (loanDetail as? LoanDetailDTO)?.number ?? "")
        let ids = actions?.compactMap({ PLLoanOperativeIdentifier(rawValue: $0) }).sorted(by: { $0.order < $1.order })
        let operations = ids?.map({
            LoanOption(
                title: $0.textKey,
                imageName: $0.icon,
                accessibilityIdentifier: $0.textKey,
                type: $0.type,
                titleIdentifier: $0.textKey,
                imageIdentifier: $0.icon
            )
        })
        return Just(operations ?? [loanScheduleButton, detail]).eraseToAnyPublisher()
    }
}

private extension PLGetLoanOptionsUsecase {
    var loanScheduleButton: LoanOption {
        LoanOption(title: "loansOption_button_loanSchedule",
                   imageName: "icnLoanSchedule",
                   accessibilityIdentifier: AccessibilityIDLoansHome.optionScheduleContainer.rawValue,
                   type: .custom(identifier: "loansOption_button_loanSchedule"),
                   titleIdentifier: "loansOption_button_loanSchedule",
                   imageIdentifier: "icnLoanSchedule")
    }
    var customerServiceButton: LoanOption {
        LoanOption(title: "loansOption_button_customerService",
                   imageName: "icnCustomerService",
                   accessibilityIdentifier: AccessibilityIDLoansHome.optionCustomerServiceContainer.rawValue,
                   type: .custom(identifier: "loansOption_button_customerService"),
                   titleIdentifier: "loansOption_button_customerService",
                   imageIdentifier: "icnCustomerService")
    }
    var detail: LoanOption {
        LoanOption(title: "loansOption_button_detailLoan",
                   imageName: "icnDetail",
                   accessibilityIdentifier: AccessibilityIDLoansHome.optionDetailContainer.rawValue,
                   type: .detail,
                   titleIdentifier: AccessibilityIDLoansHome.optionDetailTitleLabel.rawValue,
                   imageIdentifier: AccessibilityIDLoansHome.optionDetailImage.rawValue)
    }
}

private extension PLGetLoanOptionsUsecase {
    struct LoanOption: LoanOptionRepresentable {
        var title: String
        var imageName: String
        var accessibilityIdentifier: String
        var type: LoanOptionType
        var titleIdentifier: String?
        var imageIdentifier: String?
    }
}
