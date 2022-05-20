//
//  NoOperationToConfirmCoordinator.swift
//  Authorization
//
//  Created by 186484 on 15/04/2022.
//

import UI
import PLCommons
import CoreDomain
import CoreFoundationLib

protocol NoOperationToConfirmCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    func goBack()
    func showAuthorization(for challenge: ChallengeRepresentable)
}

final class NoOperationToConfirmCoordinator: NoOperationToConfirmCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private lazy var authorizationHandler: ChallengesHandlerDelegate = dependenciesEngine.resolve()
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: NoOperationToConfirmViewController.self)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showAuthorization(for challenge: ChallengeRepresentable) {
           authorizationHandler.handle(challenge, authorizationId: "") { [weak self] challengeResult in
               guard let self = self else { return }
               
               switch(challengeResult) {
               case .handled(_):
                   //TODO: handle success challengeResult
                   print("success")
               default:
                   //TODO: handle error challengeResult
                   print("error")
               }
           }
           removeModuleControllerFromStack()
       }
}

private extension NoOperationToConfirmCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: NoOperationToConfirmCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: NoOperationToConfirmPresenterProtocol.self) { resolver in
            return NoOperationToConfirmPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: NoOperationToConfirmViewController.self) { resolver in
            var presenter = resolver.resolve(for: NoOperationToConfirmPresenterProtocol.self)
            let viewController = NoOperationToConfirmViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is AuthorizationModuleViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
}
