//
//  AuthorizationPresenter.swift
//  Account
//
//  Created by Patryk Grabowski on 14/03/2022.
//

import Foundation
import Operative
import PLCommons
import SANPLLibrary
import PLCommonOperatives
import CoreFoundationLib

protocol AuthorizationModulePresenterProtocol: AnyObject {
    var view: AuthorizationModuleViewProtocol? { get set }
    func viewDidLoad()
    func didTapCloseProcess()
}

final class AuthorizationModulePresenter {
    weak var view: AuthorizationModuleViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    
    private var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve(for: UseCaseHandler.self)
    }

    private var coordinator: AuthorizationModuleCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
        
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension AuthorizationModulePresenter: AuthorizationModulePresenterProtocol {
    func viewDidLoad() {
        let appRepository = self.dependenciesResolver.resolve(for: AppRepositoryProtocol.self)
        let userId = try? appRepository.getPersistedUser().getResponseData()?.userId
        
        view?.showLoader()

        Scenario(
            useCase: AuthorizationGetPendingChallengeUseCase(dependenciesResolver: dependenciesResolver),
            input: AuthorizationGetPendingChallengeUseCaseInput(userId: userId)
        )
        .execute(on: useCaseHandler)
        .onSuccess { [weak self] output in
            self?.view?.hideLoader(completion: {
                self?.coordinator.showAuthorization(for: output)
            })
        }
        .onError { [weak self] _ in
            self?.view?.hideLoader(completion: {
                self?.coordinator.showEmptyAuthorization()
            })
        }
    }
    
    private func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator.close()
        })
    }
    
    func didTapCloseProcess() {
        coordinator.close()
    }
}
