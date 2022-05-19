//
//  NoOperationToConfirmPresenter.swift
//  Authorization
//
//  Created by 186484 on 19/04/2022.
//

import CoreFoundationLib

protocol NoOperationToConfirmPresenterProtocol {
    var view: NoOperationToConfirmViewProtocol? { get set }

    func viewDidLoad()
    func refreshOperations()
    func didConfirmClosing()
    func backButtonSelected()
}

final class NoOperationToConfirmPresenter {
    weak var view: NoOperationToConfirmViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    private var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    var coordinator: NoOperationToConfirmCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: NoOperationToConfirmCoordinatorProtocol.self)
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension NoOperationToConfirmPresenter: NoOperationToConfirmPresenterProtocol {
        
    func viewDidLoad() {
        view?.setLabels(title: "generic_label_empty", description: localized("pl_generic_text_noTransactionsToConfirm"))
    }
    
    func refreshOperations() {
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
                
            })
        }
    }
    
    func didConfirmClosing() {
        coordinator.onCloseConfirmed?()
    }
    
    func backButtonSelected() {
        coordinator.onCloseConfirmed?()
    }
}

extension NoOperationToConfirmPresenter: AutomaticScreenActionTrackable {
    var trackerPage: EmptyOperationPage {
        EmptyOperationPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

public struct EmptyOperationPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }
    public init() {}
}
