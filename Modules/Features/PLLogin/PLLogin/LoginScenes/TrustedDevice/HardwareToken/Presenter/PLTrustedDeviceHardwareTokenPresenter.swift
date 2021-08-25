//
//  PLTrustedDeviceHardwareTokenPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 23/8/21.
//

import Models
import Commons
import PLCommons
import os

protocol PLTrustedDeviceHardwareTokenPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceHardwareTokenViewProtocol? { get set }
    func viewDidLoad()
    func goToDeviceTrustDeviceData()
}

final class PLTrustedDeviceHardwareTokenPresenter {
    weak var view: PLTrustedDeviceHardwareTokenViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTrustedDeviceHardwareTokenPresenter {
    var coordinator: PLTrustedDeviceHardwareTokenCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDeviceHardwareTokenCoordinatorProtocol.self)
    }
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
}

extension PLTrustedDeviceHardwareTokenPresenter: PLTrustedDeviceHardwareTokenPresenterProtocol {
    func viewDidLoad() {
    }

    func goToDeviceTrustDeviceData() {
        self.coordinator.goToDeviceTrustDeviceData()
    }
}

extension PLTrustedDeviceHardwareTokenPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return view
    }

    func genericErrorPresentedWith(error: PLGenericError) {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToDeviceTrustDeviceData()
        })
    }
}
