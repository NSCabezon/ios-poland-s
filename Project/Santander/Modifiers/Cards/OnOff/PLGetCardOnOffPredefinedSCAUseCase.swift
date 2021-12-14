//
//  PLGetCardOnOffPredefinedSCAUseCase.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 15/10/21.
//

import Foundation

import Cards
import Commons
import CoreFoundationLib
import Models
import Operative
import SANLegacyLibrary
import CoreDomain
import UI

final class PLGetCardOnOffPredefinedSCAUseCase: UseCase<Void, GetCardOnOffPredefinedSCAUseCaseOkOutput, StringErrorOutput> {
    private let provider: BSANManagersProvider

    init(dependenciesResolver: DependenciesResolver) {
        self.provider = dependenciesResolver.resolve()
    }

    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetCardOnOffPredefinedSCAUseCaseOkOutput, StringErrorOutput> {
        let response = self.provider.getBsanPredefineSCAManager().getCardOnOffPredefinedSCA()
        guard response.isSuccess(), let representable = try response.getResponseData(), let predefineSCAEntity = PredefinedSCAEntity(rawValue: representable.rawValue) else {
            return .ok(GetCardOnOffPredefinedSCAUseCaseOkOutput(predefinedSCAEntity: nil))
        }
        return .ok(GetCardOnOffPredefinedSCAUseCaseOkOutput(predefinedSCAEntity: predefineSCAEntity))
    }
}

extension PLGetCardOnOffPredefinedSCAUseCase: GetCardOnOffPredefinedSCAUseCaseProtocol {}
