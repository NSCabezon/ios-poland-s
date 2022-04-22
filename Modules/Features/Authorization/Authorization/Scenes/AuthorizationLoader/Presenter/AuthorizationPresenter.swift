//
//  AuthorizationPresenter.swift
//  Account
//
//  Created by Patryk Grabowski on 14/03/2022.
//

import CoreFoundationLib
import PLCommons
import PLCommonOperatives
import SANPLLibrary
import PLLogin


protocol AuthorizationPresenterProtocol {
    var view: AuthorizationView? { get set }
    func didTapBack()
    func viewDidLoad()
}

final class AuthorizationPresenter {
    weak var view: AuthorizationView?
    private let dependenciesResolver: DependenciesResolver

    private var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    private var coordinator: AuthorizationCoordinatorProtocol {
        dependenciesResolver.resolve()
    }

     
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
    func viewDidLoad() {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else { return }
        
        Scenario(
            useCase: PLRememberedLoginPendingChallengeUseCase(dependenciesResolver: dependenciesResolver),
            input: PLRememberedLoginPendingChallengeUseCaseInput(userId: String(userId))
        )
        .execute(on: useCaseHandler)
        .onSuccess { [weak self] output in
            self?.didSuccessOnPendingChallengeBeforeLogin(with: output)
        }
        .onError { [weak self] error in
            self?.didCheckPendingChallengeBeforeLogin(hasChallenge: true)
        }
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    private func didCheckPendingChallengeBeforeLogin(hasChallenge: Bool) {
        // TODO: Navigate to the appropriate screen based on miro's designs.
    }
    
    private func didSuccessOnPendingChallengeBeforeLogin(with challenge: PLRememberedLoginPendingChallenge) {
        // TODO: Choose from PIN, PIN with Biometrics, or 3DSecure authorization and navigate there.
    }
}
