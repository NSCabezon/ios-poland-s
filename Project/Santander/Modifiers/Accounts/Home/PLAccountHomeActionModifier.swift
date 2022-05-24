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
import BLIK
import UI

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    private let legacyDependenciesResolver: DependenciesResolver
    private let dependencies: ModuleDependencies
    
    private var subscriptions: Set<AnyCancellable> = []
    
    public init(dependencies: ModuleDependencies) {
        self.legacyDependenciesResolver = dependencies.resolve()
        self.dependencies = dependencies
    }
    
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        if case .custome(let identifier, _, _, _, _, _, _) = action {
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
                goToSendMoney(with: entity.representable)
            case .changeAliases:
                goToPGProductsCustomization()
            case .blik:
                goToBLIK()
            default:
                Toast.show(localized("generic_alert_notAvailableOperation"))
            }
        } else if case .transfer = action {
            goToSendMoney(with: entity.representable)
        }
    }
    
    func getActionButtonFillViewType(for accountType: AccountActionType) -> ActionButtonFillViewType? {
        return nil
    }
}

extension PLAccountHomeActionModifier {
    private func showWebView(identifier: String, entity: AccountEntity) {
        let input: GetPLAccountOtherOperativesWebConfigurationUseCaseInput
        let repository = legacyDependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let list = repository.get()?.accountsOptions, var data = getAccountOtherOperativesEntity(list: list, identifier: identifier) else { return }
        if identifier == PLAccountOperativeIdentifier.editGoal.rawValue {
            data.parameter = entity.productIdentifier
        }
        if let isAvailable = data.isAvailable, !isAvailable {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }
        input = GetPLAccountOtherOperativesWebConfigurationUseCaseInput(type: data)
        let useCase = legacyDependenciesResolver.resolve(for: GetPLAccountOtherOperativesWebConfigurationUseCase.self)
        Scenario(useCase: useCase, input: input)
            .execute(on: legacyDependenciesResolver.resolve())
            .onSuccess { [weak self] result in
                self?.legacyDependenciesResolver.resolve(for: AccountsHomeCoordinatorDelegate.self).goToWebView(configuration: result.configuration)
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
        checkNewSendMoneyHomeIsEnabled
            .fetchEnabled()
            .receive(on: Schedulers.main)
            .sink { [unowned self] isEnabled in
                if isEnabled {
                    self.dependencies.transferHomeCoordinator()
                        .set(account)
                        .start()
                } else {
                    self.sendMoneyCoordinator
                        .set(account)
                        .start()
                }
            }
            .store(in: &subscriptions)
    }
}

private extension PLAccountHomeActionModifier {
    var checkNewSendMoneyHomeIsEnabled: CheckNewSendMoneyHomeEnabledUseCase {
        return dependencies.resolve()
    }
    
    var sendMoneyCoordinator: SendMoneyCoordinatorProtocol {
        return legacyDependenciesResolver.resolve()
    }
    
    private func goToPGProductsCustomization() {
        let coordinator = legacyDependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
    
    private func goToBLIK() {
        let blikCoordinator: BLIKHomeCoordinator = legacyDependenciesResolver.resolve()
        blikCoordinator.start()
    }
}
