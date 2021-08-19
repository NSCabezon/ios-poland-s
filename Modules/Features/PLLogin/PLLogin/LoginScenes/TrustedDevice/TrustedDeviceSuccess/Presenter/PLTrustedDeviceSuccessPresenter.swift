//
//  PLTrustedDeviceSuccessPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 13/8/21.
//

import Models
import Commons
import PLCommons
import os

protocol PLTrustedDeviceSuccessPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSuccessViewProtocol? { get set }
    func viewDidLoad()
}

final class PLTrustedDeviceSuccessPresenter {
    weak var view: PLTrustedDeviceSuccessViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTrustedDeviceSuccessPresenter {
    var coordinator: PLTrustedDeviceSuccessCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDeviceSuccessCoordinatorProtocol.self)
    }
}

extension PLTrustedDeviceSuccessPresenter: PLTrustedDeviceSuccessPresenterProtocol {
    func viewDidLoad() {
    }
}
