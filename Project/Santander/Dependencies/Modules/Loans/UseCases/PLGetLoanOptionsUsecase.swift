//
//  PLGetLoanOptionsUsecase.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/31/21.
//

import Loans
import Commons
import CoreDomain
import Foundation
import OpenCombine

struct PLGetLoanOptionsUsecase {}

extension PLGetLoanOptionsUsecase: GetLoanOptionsUsecase {
    func fetchOptionsPublisher() -> AnyPublisher<[LoanOptionRepresentable], Never> {
        let options = [loanScheduleButton, customerServiceButton, detail]
        return Just(options).eraseToAnyPublisher()
    }
    
    func fetchOptionsPublisher(loanDetail: LoanDetailRepresentable) -> AnyPublisher<[LoanOptionRepresentable], Never> {
        return Just([]).eraseToAnyPublisher()
    }
}

private extension PLGetLoanOptionsUsecase {
    var loanScheduleButton: LoanOption {
        LoanOption(title: "loansOption_button_loanSchedule",
                   imageName: "icnLoanSchedule",
                   accessibilityIdentifier: "loansOption_button_loanSchedule",
                   type: .custom(identifier: "loansOption_button_loanSchedule"),
                   titleIdentifier: "loansOption_button_loanSchedule",
                   imageIdentifier: "icnLoanSchedule")
    }
    var customerServiceButton: LoanOption {
        LoanOption(title: "loansOption_button_customerService",
                   imageName: "icnCustomerService",
                   accessibilityIdentifier: "loansOption_button_customerService",
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
