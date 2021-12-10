//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import UI
import Models
import Account
import Commons
import Foundation

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        if case .custome(let identifier, _, _, _, _, _) = action {
            switch identifier {
            case PLAccountOtherOperativesIdentifier.savingGoals.rawValue:
                showWebView(identifier: identifier, entity: entity)
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        } else if case .transfer = action {
            goToSendMoney()
        }
    }
    
    func getActionButtonFillViewType(for accountType: AccountActionType) -> ActionButtonFillViewType? {
        return nil
    }
    
}

extension PLAccountHomeActionModifier {
    private func showWebView(identifier: String, entity: AccountEntity) {
        let input: GetPLAccountOtherOperativesWebConfigurationUseCaseInput
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.accountsOptions, var data = getAccountOtherOperativesEntity(list: list, identifier: identifier) else { return }
        if identifier == PLAccountOtherOperativesIdentifier.editGoal.rawValue { 
            data.parameter = entity.productIdentifier
        }
        if let isAvailable = data.isAvailable, !isAvailable {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }
        input = GetPLAccountOtherOperativesWebConfigurationUseCaseInput(type: data)
        let useCase = self.dependenciesResolver.resolve(for: GetPLAccountOtherOperativesWebConfigurationUseCase.self)
        Scenario(useCase: useCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { result in
                self.dependenciesResolver.resolve(for: AccountsHomeCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
            }
    }
    
    private func getAccountOtherOperativesEntity(list: [PLAccountOtherOperativesDTO], identifier: String) -> PLAccountOtherOperativesData? {
        var entity: PLAccountOtherOperativesData?
        for dto in list where dto.id == identifier {
            entity = PLAccountOtherOperativesData(identifier: identifier, link: dto.url, isAvailable: dto.isAvailable, parameter: nil, isFullScreen: dto.isFullScreen)
        }
        return entity
    }

    private func goToSendMoney() {
        let useCase = CheckNewSendMoneyEnabledUseCase(dependenciesResolver: self.dependenciesResolver)
        Scenario(useCase: useCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { enabled in
                if enabled {
                    self.dependenciesResolver.resolve(for: SendMoneyCoordinatorProtocol.self).start()
                } else {
                    Toast.show(localized("generic_alert_notAvailableOperation"))
                }
            }
    }
}
