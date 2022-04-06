//
//  TaxBillingPeriodViewModelMapper.swift
//  TaxTransfer
//
//  Created by 187831 on 09/03/2022.
//

protocol TaxBillingPeriodViewModelMapping {
    func map(
        _ period: TaxTransferBillingPeriodType,
        year: String,
        periodNumber: Int?
    ) -> TaxTransferFormViewModel.TaxBillingPeriodViewModel
}

final class TaxBillingPeriodViewModelMapper: TaxBillingPeriodViewModelMapping {
    func map(
        _ period: TaxTransferBillingPeriodType,
        year: String,
        periodNumber: Int?
    ) -> TaxTransferFormViewModel.TaxBillingPeriodViewModel {
        return TaxTransferFormViewModel.TaxBillingPeriodViewModel(
            periodType: period,
            year: year,
            periodNumber: periodNumber
        )
    }
}
