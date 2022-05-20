//
//  PLSavingsCustomOptionCoordinator.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 26/4/22.
//

import Foundation
import SavingProducts
import UI
import CoreDomain
import CoreFoundationLib

final class PLSavingsCustomOptionCoordinator: BindableCoordinator {
    var dataBinding: DataBinding = DataBindingObject()
    var onFinish: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    private var externalDependenciesResolver: SavingsHomeExternalDependenciesResolver

    init(dependencies: SavingsHomeExternalDependenciesResolver, navigationController: UINavigationController?) {
        self.externalDependenciesResolver = dependencies
        self.navigationController = navigationController
    }

    func start() {
        guard let option: SavingProductOptionRepresentable = dataBinding.get(),
              case .custom(let identifier) = option.type else {
                  return
              }

        switch identifier {
        case PLSavingProductOption.savingDetails.rawValue.lowercased(), PLSavingProductOption.termDetails.rawValue.lowercased():
            didSelectSavingDetail()
        default:
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }
}

private extension PLSavingsCustomOptionCoordinator {
    func didSelectSavingDetail() {
        guard let saving: SavingProductRepresentable = dataBinding.get() else { return }
        let coordinator = externalDependenciesResolver.savingDetailCoordinator()
        coordinator.set(saving)
            .start()
        append(child: coordinator)
    }
}
