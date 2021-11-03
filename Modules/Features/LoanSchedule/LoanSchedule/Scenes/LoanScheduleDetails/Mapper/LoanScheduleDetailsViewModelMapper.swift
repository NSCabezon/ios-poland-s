//
//  DeleteAliasViewModelMapper.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import Commons

protocol LoanScheduleDetailsViewModelMapping {
    func map(_ item: LoanSchedule.ItemEntity) -> LoanScheduleDetailsViewModel
}

final class LoanScheduleDetailsViewModelMapper: LoanScheduleDetailsViewModelMapping {
    func map(_ item: LoanSchedule.ItemEntity) -> LoanScheduleDetailsViewModel {
        LoanScheduleDetailsViewModel(elements: [
            LoanScheduleDetailsViewModel.Element(
                title: localized("pl_loanSchedule_label_installmentDate"),
                value: item.date.toString(format: TimeFormat.ddMMyyyy.rawValue),
                valueStyle: .medium,
                separatorLine: .none),
            LoanScheduleDetailsViewModel.Element(
                title: localized("pl_loanSchedule_label_installmentAmount"),
                value: item.amount.getFormattedAmountUI(),
                valueStyle: .big,
                separatorLine: .whole),
            LoanScheduleDetailsViewModel.Element(
                title: localized("pl_loanSchedule_label_capitalAmount"),
                value: item.principalAmount.getFormattedAmountUI(),
                valueStyle: .small,
                separatorLine: .withMargins),
            LoanScheduleDetailsViewModel.Element(
                title: localized("pl_loanSchedule_label_interestAmount"),
                value: item.interestAmount.getFormattedAmountUI(),
                valueStyle: .small,
                separatorLine: .withMargins),
            LoanScheduleDetailsViewModel.Element(
                title: localized("pl_loanSchedule_label_capitalBalance"),
                value: item.balanceAfterPayment.getFormattedAmountUI(),
                valueStyle: .small,
                separatorLine: .withMargins)
        ])
    }
}
