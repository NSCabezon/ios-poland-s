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
    func continueButtonDidPressed()
}

final class PLTrustedDeviceSuccessPresenter {
    weak var view: PLTrustedDeviceSuccessViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesResolver.resolve(for: PLSessionUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    private var notificationGetTokenAndRegisterUseCase: PLGetNotificationTokenAndRegisterUseCase {
        return self.dependenciesResolver.resolve(for: PLGetNotificationTokenAndRegisterUseCase.self)
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
        self.notificationGetTokenAndRegisterUseCase.executeUseCase {}
    }
}

//MARK: - Private Methods
private extension  PLTrustedDeviceSuccessPresenter {

    func openSessionAndNavigateToGlobalPosition() {
        Scenario(useCase: self.sessionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] _ -> Scenario<Void, GetGlobalPositionOptionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.globalPositionOptionUseCase)
            })
            .onSuccess( { [weak self] output in
                self?.goToGlobalPosition(output.globalPositionOption)

            })
            .onError { [weak self] _ in
                self?.goToGlobalPosition(.classic)
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
