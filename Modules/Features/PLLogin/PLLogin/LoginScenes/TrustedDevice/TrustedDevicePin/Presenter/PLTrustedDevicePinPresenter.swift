//
//  PLTrustedDevicePinPresenter.swift
//  PLLogin

import Models
import Commons

protocol PLTrustedDevicePinPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDevicePinViewProtocol? { get set }
    func viewDidLoad()
    
}

final class PLTrustedDevicePinPresenter {
    weak var view: PLTrustedDevicePinViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTrustedDevicePinPresenter {
    var coordinator: PLTrustedDevicePinCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDevicePinCoordinatorProtocol.self)
    }

}

extension PLTrustedDevicePinPresenter: PLTrustedDevicePinPresenterProtocol {
    func viewDidLoad() {
        //TODO:
    }
}
