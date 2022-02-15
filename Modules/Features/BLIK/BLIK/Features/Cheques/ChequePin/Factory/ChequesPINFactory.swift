//
//  ChequesPinFactory.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import CoreFoundationLib
import SANPLLibrary

public protocol ChequesPinProducing {
    func create(
        coordinator: ChequesCoordinator,
        didSetPin: @escaping () -> Void
    ) -> UIViewController
}

public final class ChequesPinFactory: ChequesPinProducing {
    private let dependenciesResolver: DependenciesResolver
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    public func create(
        coordinator: ChequesCoordinator,
        didSetPin: @escaping () -> Void
    ) -> UIViewController {
        let presenter = ChequePinPresenter(
            dependenciesResolver: dependenciesResolver,
            confirmationVisibility: .hidden,
            coordinator: coordinator,
            saveChequePinUseCase: SaveChequePinUseCase(
                dependenciesResolver: dependenciesResolver
            ),
            encryptChequePinUseCase: EncryptChequePinUseCase(
                managersProvider: dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
            ),
            validator: ChequePinValidator(),
            didSetPin: didSetPin
        )
        let controller = ChequePinViewController(
            presenter: presenter
        )
        presenter.view = controller
        return controller
    }
}

