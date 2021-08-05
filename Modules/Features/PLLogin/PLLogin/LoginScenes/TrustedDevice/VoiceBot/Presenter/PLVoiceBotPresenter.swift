//
//  VoiceBotPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import Models
import Commons
import os

protocol PLVoiceBotPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLVoiceBotViewProtocol? { get set }
    func viewDidLoad()
}

final class PLVoiceBotPresenter {
    weak var view: PLVoiceBotViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLVoiceBotPresenter {
    var coordinator: PLVoiceBotCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLVoiceBotCoordinatorProtocol.self)
    }
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
}

extension PLVoiceBotPresenter: PLVoiceBotPresenterProtocol {
    func viewDidLoad() {
    }
}

private extension PLVoiceBotPresenter {

    func goToHardwareTokenScreen() {
        self.coordinator.goToHardwareToken()
    }
}
