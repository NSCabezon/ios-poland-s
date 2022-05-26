//
//  ModuleDependencies+SavingsExternalDependenciesResolver.swift
//  Santander
//
//  Created by Jose Ignacio de Juan Díaz on 6/4/22.
//

import SavingProducts
import CoreFoundationLib
import CoreDomain
import OpenCombine
import UI

extension DefaultCheckNewSendMoneyHomeEnabledUseCase: SavingsCheckNewHomeSendMoneyIsEnabledUseCase { }

extension ModuleDependencies: SavingsExternalDependenciesResolver {
    func resolve() -> SavingsCheckNewHomeSendMoneyIsEnabledUseCase {
        return DefaultCheckNewSendMoneyHomeEnabledUseCase(dependencies: self)
    }

    func resolve() -> SavingTransactionsRepository {
        return PLSavingTransactionsRepository(dependencies: self.oldResolver)
    }

    func resolve() -> GetSavingProductOptionsUseCase {
        return PLGetSavingProductOptionsUseCase(dependencies: self)
    }
    
    func resolve() -> GetSavingProductComplementaryDataUseCase {
        PLGetSavingProductComplimentaryDataUseCase(dependencies: self)
    }
    
    func resolve() -> SavingsHomeTransactionsActionsUseCase {
        return PLSavingsHomeTransactionsActionsUseCase()
    }
    
    func resolve() -> GetSavingProductsUsecase {
        return PLGetSavingProductsUsecase(dependencies: self)
    }
    
    func savingsHomeTransactionsActionsCoordinator() -> BindableCoordinator {
        return PLSavingsHomeTransactionsActionsCoordinator(navigationController: self.resolve())
    }
    
    func savingsHomeCoordinator() -> BindableCoordinator {
        return PLCustomSavingsHomeCoordinator(dependencies: self,
                                              navigationController: self.resolve())
    }

    func resolve() -> SavingProductHomeConfigRepresentable {
        return PLSavingHomeConfiguration()
    }

    func savingsCustomOptionCoordinator() -> BindableCoordinator {
        let navigationController: UINavigationController = self.resolve()
        return PLSavingsCustomOptionCoordinator(dependencies: self, navigationController: navigationController)
    }

    public func resolve() -> GetSavingDetailsInfoUseCase {
        return PLGetSavingDetailsInfoUseCase(dependencies: self.oldResolver)
    }

    func savingsOneTransferHomeCoordinator() -> BindableCoordinator {
        return self.oneTransferHomeCoordinator()
    }

    func savingsSendMoneyCoordinator() -> ModuleCoordinator {
        return self.oldResolver.resolve(for: SendMoneyCoordinatorProtocol.self)
    }
}
