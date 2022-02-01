//
//  PLAccountOtherOperativesActionModifier.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 17/5/21.
//

import Foundation
import Account
import CoreFoundationLib
import UI
import CoreFoundationLib
import PersonalArea
import RetailLegacy

final class PLAccountOtherOperativesActionModifier: AccountOtherOperativesActionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        if case .custome(let identifier, _, _, _, _, _) = action {
            switch identifier {
            case PLAccountOtherOperativesIdentifier.addBanks.rawValue,
                 PLAccountOtherOperativesIdentifier.changeAccount.rawValue,
                 PLAccountOtherOperativesIdentifier.alerts24.rawValue,
                 PLAccountOtherOperativesIdentifier.editGoal.rawValue,
                 PLAccountOtherOperativesIdentifier.accountStatement.rawValue,
                 PLAccountOtherOperativesIdentifier.customerService.rawValue,
                 PLAccountOtherOperativesIdentifier.fxExchange.rawValue:
                showWebView(identifier: identifier, entity: entity)
            case PLAccountOtherOperativesIdentifier.changeAliases.rawValue:
                goToPGProductsCustomization()
            case PLAccountOtherOperativesIdentifier.generateQRCode.rawValue, PLAccountOtherOperativesIdentifier.creditCardRepayment.rawValue,
                 PLAccountOtherOperativesIdentifier.history.rawValue,
                 PLAccountOtherOperativesIdentifier.openDeposit.rawValue,
                 PLAccountOtherOperativesIdentifier.memberGetMember.rawValue:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        }
    }
    
    private func goToPGProductsCustomization() {
        let coordinator = dependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
    
    private func showWebView(identifier: String, entity: AccountEntity) {
        let input: GetPLAccountOtherOperativesWebConfigurationUseCaseInput
        let repository = dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.accountsOptions,
              var data = getAccountOtherOperativesEntity(list: list, identifier: identifier) else { return }
        
        if identifier == PLAccountOtherOperativesIdentifier.editGoal.rawValue {
            data.parameter = entity.productIdentifier
            if let contractNumber = entity.dto.contractNumber, let url = data.link?.replace(StringPlaceholder.Placeholder.number.rawValue, contractNumber) {
                data.link = url
            }
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
}
