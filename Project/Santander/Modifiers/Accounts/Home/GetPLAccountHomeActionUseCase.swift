import SANLegacyLibrary
import CoreFoundationLib
import Account
import SANPLLibrary

final class GetPLAccountHomeActionUseCase: UseCase<GetAccountHomeActionUseCaseInput, GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let defaultIds: [String] = [PLAccountOperativeIdentifier.details.rawValue,
                                        PLAccountOperativeIdentifier.changeAliases.rawValue,
                                        PLAccountOperativeIdentifier.customerService.rawValue,
                                        PLAccountOperativeIdentifier.generateQRCode.rawValue,
                                        PLAccountOperativeIdentifier.history.rawValue]
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private enum Config {
        static let maxHomeActions = 4
    }
    
    override func executeUseCase(requestValues: GetAccountHomeActionUseCaseInput) throws -> UseCaseResponse<GetAccountHomeActionUseCaseOkOutput, StringErrorOutput> {
        return .ok(getUseCaseOkOutput(contract: requestValues.account.dto.contractNumber ?? ""))
    }
}

private extension GetPLAccountHomeActionUseCase {
    
    private func getUseCaseOkOutput(contract: String) -> GetAccountHomeActionUseCaseOkOutput {
        let productActionMatrix = self.dependenciesResolver.resolve(forOptionalType: ProductActionsShortcutsMatrix.self)
        let actions = productActionMatrix?.getEnabledOperationsIdentifiers(type: .accounts, contract: contract) ?? defaultIds
        
        let allActions = actionTypes(operatives: [.transfer, .externalTransfer, .blik, .details, .savingGoals, .addBanks, .changeAliases], available: actions)
        let itemsCount = min(allActions.count, Config.maxHomeActions)
        guard itemsCount > 0 else { return GetAccountHomeActionUseCaseOkOutput(actions: []) }
        let result = Array(allActions[0...(itemsCount-1)])
        return GetAccountHomeActionUseCaseOkOutput(actions: result)
    }
    
    private func actionTypes(operatives: [PLAccountOperativeIdentifier], available: [String]) -> [AccountActionType] {
        return operatives.filter { operative in available.contains(operative.rawValue) }.map { operative in
            return actionType(operative: operative)
        }
    }
    
    private func actionType(operative: PLAccountOperativeIdentifier) -> AccountActionType {
        return AccountActionType.custome(identifier: operative.rawValue,
                                         accesibilityIdentifier: operative.rawValue,
                                         trackName: operative.rawValue,
                                         localizedKey: operative.textKey,
                                         icon: operative.icon,
                                         renderingMode: operative.rendering)
    }
}

extension GetPLAccountHomeActionUseCase: GetAccountHomeActionUseCaseProtocol {}
