//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import UI
import CoreFoundationLib
import Account
import Foundation
import PersonalArea
import BLIK

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        if case .custome(let identifier, _, _, _, _, _) = action {
            guard let actionKey = PLAccountOperativeIdentifier(rawValue: identifier) else {
                Toast.show(localized("generic_alert_notAvailableOperation"))
                return
            }
            switch actionKey {
            case .savingGoals, .addBanks:
                showWebView(identifier: identifier, entity: entity)
            case .externalTransfer:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            case .transfer:
                goToSendMoney()
            case .changeAliases:
                goToPGProductsCustomization()
            case .blik:
                goToBLIK()
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
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
        if identifier == PLAccountOperativeIdentifier.editGoal.rawValue { 
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
    
    private func getAccountOtherOperativesEntity(list: [PLProductOperativesDTO], identifier: String) -> PLProductOperativesData? {
        var entity: PLProductOperativesData?
        for dto in list where dto.id == identifier {
            entity = PLProductOperativesData(identifier: identifier, link: dto.url, isAvailable: dto.isAvailable, parameter: nil, isFullScreen: dto.isFullScreen)
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
    
    private func goToPGProductsCustomization() {
        let coordinator = dependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
    
    private func goToBLIK() {
        let blikCoordinator: BLIKHomeCoordinator = dependenciesResolver.resolve()
        blikCoordinator.start()
    }
}
