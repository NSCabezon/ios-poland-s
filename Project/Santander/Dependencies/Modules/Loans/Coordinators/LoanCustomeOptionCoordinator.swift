//
//  LoanCustomeOptionCoordinator.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/31/21.
//

import UI
import Loans
import CoreFoundationLib
import Foundation
import CoreDomain
import LoanSchedule
import RetailLegacy
import PersonalArea

final class LoanCustomeOptionCoordinator: BindableCoordinator {
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    let legacyDependenciesResolver: DependenciesResolver
    var dataBinding: DataBinding = DataBindingObject()
   
    init(dependencies: LoanExternalDependenciesResolver) {
        self.legacyDependenciesResolver = dependencies.resolve()
    }
    
    func start() {
        guard let option: LoanOptionRepresentable = dataBinding.get(),
              case .custom(let identifier) = option.type else {
            return
        }
        
        switch identifier {
        case "loansOption_button_customerService":
            didSelectCustomerService()
        case "loansOption_button_loanSchedule":
            didSelectLoanSchedule()
        case "change_alias":
            goToChangeAlias()
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

private extension LoanCustomeOptionCoordinator {
    
    func didSelectCustomerService() {
        let input: GetPLAccountOtherOperativesWebConfigurationUseCaseInput
        let repository = legacyDependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        let identifier = PLAccountOperativeIdentifier.customerService.rawValue

        guard let list = repository.get()?.accountsOptions,
                let data = getAccountOtherOperativesEntity(list: list, identifier: identifier) else { return }

        input = GetPLAccountOtherOperativesWebConfigurationUseCaseInput(type: data)
        let useCase = legacyDependenciesResolver.resolve(for: GetPLAccountOtherOperativesWebConfigurationUseCase.self)
        Scenario(useCase: useCase, input: input)
            .execute(on: self.legacyDependenciesResolver.resolve())
            .onSuccess { result in
                self.legacyDependenciesResolver
                    .resolve(for: BaseWebViewNavigatableLauncher.self)
                    .goToWebView(configuration: result.configuration, type: nil, didCloseClosure: nil)
            }
    }

    func getAccountOtherOperativesEntity(list: [PLProductOperativesDTO], identifier: String) -> PLProductOperativesData? {
        let dto = list.filter { $0.id == identifier }.first
        return PLProductOperativesData(identifier: identifier, link: dto?.url, isAvailable: dto?.isAvailable, parameter: nil)
    }

    func didSelectLoanSchedule() {
        var loanEntity: LoanEntity?
        if let loan: LoanRepresentable = dataBinding.get() {
           loanEntity = LoanEntity(loan)
        }
        let coordinator = self.legacyDependenciesResolver.resolve(for: LoanScheduleModuleCoordinator.self)
        let schedule = LoanScheduleIdentity(loanAccountNumber: loanEntity?.dto.contractDescription ?? "", loanName: loanEntity?.alias ?? "")
        coordinator.start(with: schedule)
    }
    
    func goToChangeAlias() {
        let coordinator = legacyDependenciesResolver.resolve(for: PersonalAreaModuleCoordinator.self)
        coordinator.goToGPProductsCustomization()
    }
}
