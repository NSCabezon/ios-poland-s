//
//  PLTrustedDeviceSuccessPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 13/8/21.
//

import CoreFoundationLib
import Commons
import PLCommons
import os

protocol PLTrustedDeviceSuccessPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSuccessViewProtocol? { get set }
    func viewDidLoad()
    func continueButtonDidPressed()
}

final class PLTrustedDeviceSuccessPresenter {
    weak var view: PLTrustedDeviceSuccessViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var notificationTokenRegisterProcessGroup: PLNotificationTokenRegisterProcessGroup {
        return self.dependenciesResolver.resolve(for: PLNotificationTokenRegisterProcessGroup.self)
    }

    private var openSessionProcessGroup: PLOpenSessionProcessGroup {
        return self.dependenciesResolver.resolve(for: PLOpenSessionProcessGroup.self)
    }
}

private extension PLTrustedDeviceSuccessPresenter {
    var coordinator: PLTrustedDeviceSuccessCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLTrustedDeviceSuccessCoordinatorProtocol.self)
    }
}

extension PLTrustedDeviceSuccessPresenter: PLTrustedDeviceSuccessPresenterProtocol {
    func viewDidLoad() {
        self.trackScreen()
    }

    func continueButtonDidPressed() {
        self.trackEvent(.clickContinue)
        self.view?.showLoading(completion: { [weak self] in
            self?.openSessionAndNavigateToGlobalPosition()
        })
        self.notificationTokenRegisterProcessGroup.execute { _ in }
    }
}

//MARK: - Private Methods
private extension  PLTrustedDeviceSuccessPresenter {

    func openSessionAndNavigateToGlobalPosition() {
        openSessionProcessGroup.execute { [weak self] result in
            switch result {
            case .success(let output):
                self?.coordinator.goToGlobalPositionScene(output.globalPositionOption)
            case .failure(_):
                self?.coordinator.goToGlobalPositionScene(.classic)
            }
        }
    }

    func goToGlobalPosition(_ option: GlobalPositionOptionEntity) {
        self.coordinator.goToGlobalPositionScene(option)
    }
}

extension PLTrustedDeviceSuccessPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLLoginTrustedDeviceSuccessPage {
        return PLLoginTrustedDeviceSuccessPage()
    }
}
