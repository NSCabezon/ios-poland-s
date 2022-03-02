//
//  PLTermsAndConditionsPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 7/2/22.
//

import PLCommons
import CoreFoundationLib

protocol PLTermsAndConditionsPresenterProtocol {
    var view: PLTermsAndConditionsViewProtocol? { get set }
    func viewDidLoad()
    func acceptButtonDidPressed()
    func cancelButtonDidPressed()
    func trackScrollDown()
}

final class PLTermsAndConditionsPresenter {
    weak var view: PLTermsAndConditionsViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var rememberedLoginChangeUserUseCase: PLRememberedLoginChangeUserUseCase {
        self.dependenciesResolver.resolve(for: PLRememberedLoginChangeUserUseCase.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLTermsAndConditionsPresenter {
    var coordinator: PLTermsAndConditionsCoordinatorProtocol {
        dependenciesResolver.resolve(for: PLTermsAndConditionsCoordinatorProtocol.self)
    }
}

// MARK: TermsAndConditionsPresenterProtocol
extension PLTermsAndConditionsPresenter: PLTermsAndConditionsPresenterProtocol {
    func viewDidLoad() {
        self.trackScreen()
    }

    func acceptButtonDidPressed() {
        self.trackEvent(.clickAccept)
        let termsUseCase = PLTermsAndConditionsUseCase(dependenciesResolver: self.dependenciesResolver)
        let input = PLTermsAndConditionsUseCaseInput(acceptCurrentVersion: true)
        Scenario(useCase: termsUseCase, input: input).execute(on: self.dependenciesResolver.resolve()).onSuccess { [weak self] _ in
            self?.view?.dismissViewController()
            self?.coordinator.acceptTerms()
        }.onError { [weak self] error in
            self?.handleError(error)
        }
    }

    func cancelButtonDidPressed() {
        self.trackEvent(.clickCancel)
        Scenario(useCase: self.rememberedLoginChangeUserUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] _ in
                self?.coordinator.rejectTerms()
                self?.view?.dismissViewController()
            }.onError { [weak self] _ in
                self?.coordinator.rejectTerms()
                self?.view?.dismissViewController()
            }
    }

    func trackScrollDown() {
        self.trackEvent(.scrollDown)
    }
}

extension PLTermsAndConditionsPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
       
    }
}

extension PLTermsAndConditionsPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
    
    var trackerPage: PLTermsAndConditionsPage {
        return PLTermsAndConditionsPage()
    }
}
