//
//  PLValidateCardOnOffUseCase.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 15/10/21.
//

import Foundation
import Cards
import CoreDomain
import Commons
import DomainCommon
import SANLegacyLibrary
import Models

final class PLValidateCardOnOffUseCase: UseCase<ValidateCardOnOffUseCaseInput, ValidateCardOnOffUseCaseOkOutput, StringErrorOutput> {
    private let provider: BSANManagersProvider

    init(dependenciesResolver: DependenciesResolver) {
        self.provider = dependenciesResolver.resolve()
    }

    override func executeUseCase(requestValues: ValidateCardOnOffUseCaseInput) throws -> UseCaseResponse<ValidateCardOnOffUseCaseOkOutput, StringErrorOutput> {
        let response = try provider.getBsanCardsManager().onOffCard(cardDTO: requestValues.card.dto, option: requestValues.blockType)
        guard response.isSuccess() else {
            return UseCaseResponse.error(StringErrorOutput(try response.getErrorMessage() ?? ""))
        }
        return UseCaseResponse.ok(ValidateCardOnOffUseCaseOkOutput(sca: SCAEntity(ValidateCardOnOffNoneSCA())))
    }
}

extension PLValidateCardOnOffUseCase: ValidateCardOnOffUseCaseProtocol {}

private final class ValidateCardOnOffNoneSCA: SCARepresentable {
    var type: SCARepresentableType { return .none(self) }
}
