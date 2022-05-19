//
//  PLGlobalPositionSavingsModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 30/4/22.
//

import Foundation
import GlobalPosition
import CoreFoundationLib
import CoreDomain

class PLPGProductModifierUseCase: UseCase<Any, PGGeneralCellViewModelProtocol?, StringErrorOutput>, PGGeneralCellViewConfigUseCase {
    
    override func executeUseCase(requestValues: Any) throws -> UseCaseResponse<PGGeneralCellViewModelProtocol?, StringErrorOutput> {
        switch requestValues {
        case let entity as SavingProductEntity:
            return .ok(savingsViewModel(entity: entity))
        default: return .ok(nil)
        }
    }
    
    private func savingsViewModel(entity: SavingProductEntity) -> PGGeneralCellViewModelProtocol? {
        guard entity.dto.accountSubType == "GOAL" else { return nil }
        var viewModel = PGGeneralCellViewModel()
        viewModel.title = entity.alias
        viewModel.subtitle = ""
        return viewModel
    }
}
