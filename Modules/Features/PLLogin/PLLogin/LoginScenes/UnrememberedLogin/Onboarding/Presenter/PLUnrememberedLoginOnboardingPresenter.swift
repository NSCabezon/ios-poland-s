//
//  PLUnrememberedLoginOnboardingPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 20/9/21.
//

import Foundation
import Commons
import LoginCommon

protocol PLUnrememberedLoginOnboardingPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLUnrememberedLoginOnboardingProtocol? { get set }
    func didSelectLogin()
    func didSelectCreateAccount()
}

final class PLUnrememberedLoginOnboardingPresenter {
    weak var view: PLUnrememberedLoginOnboardingProtocol?
    internal let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLUnrememberedLoginOnboardingPresenter {
    var coordinator: PLUnrememberedLoginOnboardingCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginOnboardingCoordinatorProtocol.self)
    }
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }
}

extension PLUnrememberedLoginOnboardingPresenter: PLUnrememberedLoginOnboardingPresenterProtocol {
    
    func didSelectMenu() {
        coordinatorDelegate.didSelectMenu()
    }
    
    func didSelectLogin() {
        coordinator.didSelectLogin()
    }
    
    func didSelectCreateAccount() {
        coordinator.didSelectCreateAccount()
    }
}
