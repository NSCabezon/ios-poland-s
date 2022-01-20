import RetailLegacy
import Commons
import CoreFoundationLib

struct AdditionalUseCasesProviderImpl: AdditionalUseCasesProviderProtocol {
    let dependencies: DependenciesResolver

    func getAdditionalPublicFilesUseCases() -> [(useCase: UseCase<Void, Void, StringErrorOutput>, isMandatory: Bool)] {
        return [(LoadPLAccountOtherOperativesInfoUseCase(dependencies: dependencies),
                 isMandatory: true),
                (LoadPLTransferSettingsUseCase(dependencies: dependencies),
                 isMandatory: true),
                (LoadPLHelpCenterOnlineAdvisorUseCase(dependencies: dependencies),
                 isMandatory: true),
                (LoadPLHelpHelpQuestionsUseCase(dependencies: dependencies),
                 isMandatory: true)
        ]
    }
}
