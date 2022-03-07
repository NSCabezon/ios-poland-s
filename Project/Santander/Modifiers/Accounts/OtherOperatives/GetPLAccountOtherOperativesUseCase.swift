import SANLegacyLibrary
import CoreFoundationLib
import Account
import RetailLegacy

final class GetPLAccountOtherOperativesActionUseCase: UseCase<GetAccountOtherOperativesActionUseCaseInput, GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let defaultIds: [String] = [PLAccountOperativeIdentifier.details.rawValue,
                                        PLAccountOperativeIdentifier.changeAliases.rawValue,
                                        PLAccountOperativeIdentifier.customerService.rawValue,
                                        PLAccountOperativeIdentifier.generateQRCode.rawValue,
                                        PLAccountOperativeIdentifier.history.rawValue]
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetAccountOtherOperativesActionUseCaseInput) throws -> UseCaseResponse<GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
        guard let entityCode = requestValues.account.dto.contractNumber else { return .error(StringErrorOutput(nil)) }
        return .ok(getUseCaseOkOutput(contract: entityCode))
    }
    
    private func getUseCaseOkOutput(contract: String) -> GetAccountOtherOperativesActionUseCaseOkOutput {
        
        let productActionMatrix = self.dependenciesResolver.resolve(forOptionalType: ProductActionsShortcutsMatrix.self)
        let actions = productActionMatrix?.getEnabledOperationsIdentifiers(type: .accounts, contract: contract) ?? defaultIds

        let everyDay = actionTypes(operatives: [.addBanks, .changeAliases, .changeAccount, .generateQRCode, .alerts24], available: actions)
        let other = actionTypes(operatives: [.addBanks, .changeAliases, .changeAccount, .generateQRCode, .alerts24, .editGoal, .moneyBack, .multicurrency, .atmPackage, .history, .accountStatement, .customerService, .ourOffer, .openDeposit, .fxExchange, .memberGetMember], available: actions)
        let adjustAccounts = actionTypes(operatives: [.moneyBack, .multicurrency, .atmPackage], available: actions)
        let queries = actionTypes(operatives: [.history, .accountStatement, .customerService], available: actions)
        let contract = actionTypes(operatives: [.ourOffer, .openDeposit, .fxExchange, .memberGetMember], available: actions)
        
        return GetAccountOtherOperativesActionUseCaseOkOutput(everyDayOperatives: everyDay, otherOperativeActions: other, adjustAccounts: adjustAccounts, queriesActions: queries, contractActions: contract, officeArrangementActions: [])
    }
    
    private func actionTypes(operatives: [PLAccountOperativeIdentifier], available: [String]) -> [AccountActionType] {
        return operatives.filter { operative in available.contains(operative.rawValue) }.map { operative in
            actionType(operative: operative)
        }
    }
    
    private func actionType(operative: PLAccountOperativeIdentifier) -> AccountActionType {
        return AccountActionType.custome(identifier: operative.rawValue,
                                         accesibilityIdentifier: operative.rawValue,
                                         trackName: operative.rawValue,
                                         localizedKey: operative.textKey,
                                         icon: operative.icon)
    }
}

extension GetPLAccountOtherOperativesActionUseCase: GetAccountOtherOperativesActionUseCaseProtocol {}
