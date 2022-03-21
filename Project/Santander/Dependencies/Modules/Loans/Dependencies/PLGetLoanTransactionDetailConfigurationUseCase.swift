//
//  PLGetLoanTransactionDetailConfigurationUseCase.swift
//  Santander
//
//  Created by alvola on 1/3/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib
import Loans
import OpenCombine

struct PLGetLoanTransactionDetailConfigurationUseCase { }

extension PLGetLoanTransactionDetailConfigurationUseCase: GetLoanTransactionDetailConfigurationUseCase {
    func fetchLoanTransactionDetailConfiguration() -> AnyPublisher<LoanTransactionDetailConfigurationRepresentable, Never> {
        return Just(PLLoanTransactionDetailConfiguration())
            .eraseToAnyPublisher()
    }
}

extension PLGetLoanTransactionDetailConfigurationUseCase: GetLoanTransactionDetailActionUseCase {
    func fetchLoanTransactionDetailActions() -> AnyPublisher<[LoanTransactionDetailActionRepresentable], Never> {
        return Just(detailActions())
            .eraseToAnyPublisher()
    }
}

private extension PLGetLoanTransactionDetailConfigurationUseCase {
    func detailActions() -> [LoanTransactionDetailActionRepresentable] {
        return [PLLoanTransactionDetailAction(type: LoanTransactionDetailActionType.pdfExtract(nil),
                                              isDisabled: false,
                                              isUserInteractionEnable: true),
                PLLoanTransactionDetailAction(type: LoanTransactionDetailActionType.share,
                                              isDisabled: false,
                                              isUserInteractionEnable: true)]
    }
}

struct PLLoanTransactionDetailConfiguration: LoanTransactionDetailConfigurationRepresentable {
    var fields: [(LoanTransactionDetailFieldRepresentable, LoanTransactionDetailFieldRepresentable?)] =
    [(PLLoanTransactionDetailField(title: "transaction_label_operationDate",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.transactionDateDescription.rawValue,
                                   value: .operationDate,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.transactionDateValue.rawValue),
      PLLoanTransactionDetailField(title: "transaction_label_valueDate",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.effectiveDateDescription.rawValue,
                                   value: .valueDate,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.effectiveDateValue.rawValue)),
     (PLLoanTransactionDetailField(title: "transaction_label_amount",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.capitalAmountDescription.rawValue,
                                   value: .capitalAmount,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.capitalAmountValue.rawValue),
      PLLoanTransactionDetailField(title: "transaction_label_interests",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.interestAmountDescription.rawValue,
                                   value: .interestsAmount,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.interestAmountValue.rawValue)
     ),
     (PLLoanTransactionDetailField(title: "transaction_label_recipientAccount",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.recipientAccountDescription.rawValue,
                                   value: .recipientAccount,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.recipientAccountValue.rawValue),
      nil),
     (PLLoanTransactionDetailField(title: "transaction_label_recipientData",
                                   titleAccessibility: AccessibilityIDLoansTransactionsDetail.recipientDataDescription.rawValue,
                                   value: .recipientData,
                                   valueAccessibility: AccessibilityIDLoansTransactionsDetail.recipientDataValue.rawValue),
      nil)]
}

private extension PLLoanTransactionDetailConfiguration {
    struct PLLoanTransactionDetailField: LoanTransactionDetailFieldRepresentable {
        var title: String
        var titleAccessibility: String
        var value: LoanTransactionDetailValueField
        var valueAccessibility: String
    }
}

struct PLLoanTransactionDetailAction: LoanTransactionDetailActionRepresentable {
    var type: LoanTransactionDetailActionType
    var isDisabled: Bool
    var isUserInteractionEnable: Bool
}
