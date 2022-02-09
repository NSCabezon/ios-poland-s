//
//  PLAccountHomeActionModifier.swift
//  Santander
//

import CoreFoundationLib
import OpenCombine
import CoreDomain
import Transfer
import Account
import Foundation

final class PLAccountHomeActionModifier: AccountHomeActionModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let transferHomeDependencies: OneTransferHomeExternalDependenciesResolver
    
    private var subscriptions: Set<AnyCancellable> = []
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.transferHomeDependencies = dependenciesResolver.resolve()
    }
    
    func didSelectAction(_ action: AccountActionType, _ entity: AccountEntity) {
        if case .custome(let identifier, _, _, _, _, _) = action {
            switch identifier {
            case PLAccountOtherOperativesIdentifier.savingGoals.rawValue:
                showWebView(identifier: identifier, entity: entity)
            case PLAccountOtherOperativesIdentifier.externalTransfer.rawValue:
                Toast.show(localized("generic_alert_notAvailableOperation"))
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
    
    private func goToSendMoney(with account: AccountRepresentable) {
        useCase
            .fetchEnabled()
            .receive(on: Schedulers.global)
            .sink { [unowned self] isEnabled in
                Async.main {
                    if isEnabled {
                        self.transferHomeDependencies.oneTransferHomeCoordinator()
                            .set(account)
                            .start()
                    } else {
                        self.sendMoneyCoordinator.start()
                    }
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
}
