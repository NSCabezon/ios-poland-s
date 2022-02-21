//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import CoreFoundationLib
import PersonalArea
import RetailLegacy
import OpenCombine
import CoreDomain
import Transfer
import Account
import UI

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coreDependenciesResolver: RetailLegacyExternalDependenciesResolver
    
    private var subscriptions: Set<AnyCancellable> = []
    
    public init(dependenciesResolver: DependenciesResolver, coreDependenciesResolver: RetailLegacyExternalDependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coreDependenciesResolver = coreDependenciesResolver
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
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        } else if case .transfer = action {
            goToSendMoney(with: entity.dto)
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
    
    private func goToSendMoney(with account: AccountRepresentable) {
        useCase
            .fetchEnabled()
            .receive(on: Schedulers.main)
            .sink { [unowned self] isEnabled in
                if isEnabled {
                    self.coreDependenciesResolver.oneTransferHomeCoordinator()
                        .set(account)
                        .start()
                } else {
                    self.sendMoneyCoordinator.start()
                }
            }
            .store(in: &subscriptions)
    }
}

private extension PLAccountHomeActionModifier {
    var useCase: CheckNewSendMoneyHomeEnabledUseCase {
        return dependenciesResolver.resolve()
    }
    
    var sendMoneyCoordinator: SendMoneyCoordinatorProtocol {
        return dependenciesResolver.resolve()
    }
    
    private func goToPGProductsCustomization() {
        let coordinator = dependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
}
