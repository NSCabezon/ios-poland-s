//
//  PLSetupActivateCardUseCase.swift
//  Santander
//

import Cards
import CoreFoundationLib
import Operative
import SANLegacyLibrary
import CoreDomain
import UI

final class PLSetupActivateCardUseCase: UseCase<SetupActivateCardUseCaseInput, SetupActivateCardUseCaseOkOutput, StringErrorOutput> {
    private let provider: BSANManagersProvider
    
    init(dependenciesResolver: DependenciesResolver) {
        self.provider = dependenciesResolver.resolve()
    }
    
    override func executeUseCase(requestValues: SetupActivateCardUseCaseInput) throws -> UseCaseResponse<SetupActivateCardUseCaseOkOutput, StringErrorOutput> {
        return UseCaseResponse.error(StringErrorOutput(localized("generic_alert_notAvailableOperation")))
    }
}

extension PLSetupActivateCardUseCase: SetupActivateCardUseCaseProtocol {}

struct PLSetupActivateCardUseCaseInput {
    var card: CardEntity
}

private final class SetupActivateCardNoneSCA: SCARepresentable {
    var type: SCARepresentableType { return .none(self) }
}
