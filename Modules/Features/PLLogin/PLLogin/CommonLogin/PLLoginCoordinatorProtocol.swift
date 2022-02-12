//
//  PLLoginCoordinatorProtocol.swift
//  PLLogin

import CoreFoundationLib
import CoreDomain
import LoginCommon
import UI

protocol PLLoginCoordinatorProtocol: AnyObject, OpenUrlCapable {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector { get }
    func goToPrivate(_ globalPositionOption: GlobalPositionOptionEntity)
    func goToFakePrivate(_ name: String?)
    func goToFakePrivate(isPb: Bool, name: String?)
    func backToLogin()
    func changeUser()
}

extension PLLoginCoordinatorProtocol {
    func goToPrivate(_ globalPositionOption: GlobalPositionOptionEntity) {
        let coordinatorDelegate: LoginCoordinatorDelegate = self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
        coordinatorDelegate.goToPrivate(globalPositionOption: globalPositionOption)
    }

    func goToFakePrivate(_ name: String?) {
        let coordinatorDelegate: LoginCoordinatorDelegate = self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
        coordinatorDelegate.goToFakePrivate(isPb: false, name: name)
    }

    func backToLogin() {
        let coordinatorDelegate: LoginCoordinatorDelegate = self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
        coordinatorDelegate.backToLogin()
    }

    func goToFakePrivate(isPb: Bool, name: String?) {
        self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
            .goToFakePrivate(isPb: isPb, name: name)
    }

    func changeUser() {
        let coordinator = self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
        coordinator.goToPublic(shouldGoToRememberedLogin: false)
    }

    func registerSecuritySettingsDeepLink() {
        let coordinatorDelegate: LoginCoordinatorDelegate = self.dependenciesEngine.resolve(for: LoginCoordinatorDelegate.self)
        coordinatorDelegate.registerSecuritySettingsDeepLink()
    }
}
