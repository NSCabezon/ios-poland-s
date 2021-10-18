//
//  PhoneTransferSettingsFactory.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 27/07/2021.
//

import Commons
import SANPLLibrary

protocol PhoneTransferSettingsProducing {
    func create(
        viewModel: PhoneTransferSettingsViewModel,
        coordinator: PhoneTransferSettingsCoordinatorProtocol
    ) -> PhoneTransferSettingsViewController
}

final class PhoneTransferSettingsFactory: PhoneTransferSettingsProducing {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func create(
        viewModel: PhoneTransferSettingsViewModel,
        coordinator: PhoneTransferSettingsCoordinatorProtocol
    ) -> PhoneTransferSettingsViewController {
        let presenter = PhoneTransferSettingsPresenter(
            dependenciesResolver: dependenciesResolver,
            coordinator: coordinator,
            unregisterPhoneNumberUseCase: UnregisterPhoneNumberUseCase(
                managersProvider: dependenciesResolver.resolve(
                    for: PLManagersProviderProtocol.self
                )
            )
        )
        let controller = PhoneTransferSettingsViewController(
            initialViewModel: viewModel,
            presenter: presenter
        )
        presenter.view = controller
        return controller
    }
}
