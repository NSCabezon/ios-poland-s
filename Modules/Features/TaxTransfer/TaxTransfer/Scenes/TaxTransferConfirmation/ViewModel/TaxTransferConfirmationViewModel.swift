//
//  TaxTransferConfirmationViewModel.swift
//  TaxTransfer
//
//  Created by 187831 on 03/04/2022.
//

import PLCommons
import Operative
import CoreFoundationLib

protocol TaxTransferConfirmationViewModelType {
    var items: [OperativeSummaryStandardBodyItemViewModel] { get }
    var amount: Decimal { get }
}

final class TaxTransferConfirmationViewModel: TaxTransferConfirmationViewModelType {
    var items: [OperativeSummaryStandardBodyItemViewModel] {
        return mapper.map(model)
    }
    
    var amount: Decimal {
        return model.amount
    }

    private let model: TaxTransferModel
    private let mapper: TaxOperativeSummaryMapping
    
    init(model: TaxTransferModel,
         dependenciesResolver: DependenciesResolver) {
        self.model = model
        self.mapper = dependenciesResolver.resolve(for: TaxOperativeSummaryMapping.self)
    }
}
