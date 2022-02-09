//
//  PLUnrememberedLoginOnboardingPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 20/9/21.
//

import Foundation
import CoreFoundationLib
import LoginCommon
import PLCommons

protocol PLUnrememberedLoginOnboardingPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLUnrememberedLoginOnboardingProtocol? { get set }
    func viewDidLoad()
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

    func viewDidLoad() {
        self.trackScreen()
    }

    func didSelectMenu() {
        coordinatorDelegate.didSelectMenu()
    }
    
    func didSelectLogin() {
        self.trackEvent(.clickActivateApp)
        coordinator.didSelectLogin()
    }
    
    func didSelectCreateAccount() {
        self.trackEvent(.clickOpenAccount)
        coordinator.didSelectCreateAccount()
    }
}

extension PLUnrememberedLoginOnboardingPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLUnrememberedLoginOnboardingPage {
        return PLUnrememberedLoginOnboardingPage()
    }
}
