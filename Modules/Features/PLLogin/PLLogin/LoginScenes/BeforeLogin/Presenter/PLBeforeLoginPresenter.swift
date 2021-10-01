//
//  PLBeforeLoginPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import Foundation
import Commons
import LoginCommon
import PLCommons

protocol PLBeforeLoginPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLBeforeLoginViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidAppear()
    func openAppStore()
}

final class PLBeforeLoginPresenter {
    weak var view: PLBeforeLoginViewControllerProtocol?
    internal let dependenciesResolver: DependenciesResolver
    var isDeprecatedVersion:Bool = false
    
    private var beforeLoginUseCase: PLBeforeLoginUseCase {
        self.dependenciesResolver.resolve(for: PLBeforeLoginUseCase.self)
    }
    
    private lazy var appStoreNavigator: PLAppStoreNavigator = {
        return PLAppStoreNavigator()
    }()
    
    private var coordinator: PLBeforeLoginCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLBeforeLoginCoordinatorProtocol.self)
    }
    
    private var publicFilesManager: PublicFilesManagerProtocol {
        return self.dependenciesResolver.resolve(for: PublicFilesManagerProtocol.self)
    }
    
    private var validateVersionUseCase: PLValidateVersionUseCase {
        self.dependenciesResolver.resolve(for: PLValidateVersionUseCase.self)
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLBeforeLoginPresenter {
    
    func loadData() {
        self.publicFilesManager.add(subscriptor: PLBeforeLoginPresenter.self) { [weak self] in
            self?.validateVersionAndUser()
        }
    }
    
    func validateVersionAndUser() {
        view?.loadStart()
        Scenario(useCase: validateVersionUseCase).execute(on: self.dependenciesResolver.resolve())
        .then(scenario: { [weak self] _ -> Scenario<Void, PLBeforeLoginUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
            guard let self = self else { return nil }
            return Scenario(useCase: self.beforeLoginUseCase)
        })
        .onSuccess({ [weak self] result in
            self?.navigate(isTrustedDevice: result.isTrustedDevice)
        })
        .onError({[weak self] error in
            self?.handleError(error)
        })
    }
}

extension PLBeforeLoginPresenter: PLBeforeLoginPresenterProtocol {
    
    func viewDidAppear() {
        guard isDeprecatedVersion else { return }
        self.validateVersionAndUser()
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func navigate(isTrustedDevice: Bool) {
        self.view?.loadDidFinish()
        if isTrustedDevice {
            self.coordinator.loadRememberedLogin()
        } else {
            self.coordinator.loadUnrememberedLogin()
        }
    }
    
    func openAppStore() {
        guard let viewController = self.view as? UIViewController else { return }
        appStoreNavigator.openAppStore(presenterViewController: viewController)
    }
}

extension PLBeforeLoginPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.validateVersionAndUser()
    }
    
    func handle(error: PLGenericError) {
        view?.loadDidFinish()
        switch error {
        case .other(let description):
            switch description {
            case "DEPRECATED_VERSION":
                self.isDeprecatedVersion = true
                self.view?.dismissLoading(completion: { [weak self] in
                    self?.view?.showDeprecatedVersionDialog()
                })
                return
            default:
                break
            }
        default:
            break
        }
        self.associatedErrorView?.presentError(error, completion: { [weak self] in
            self?.genericErrorPresentedWith(error: error)
        })
    }
}
