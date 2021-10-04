//
//  PLRememberedLoginPinPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Foundation
import Commons
import LoginCommon
import PLCommons
import Models

protocol PLRememberedLoginPinPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLRememberedLoginPinViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidAppear()
    func doLogin(with pin: String)
    func didSelectBalance()
    func didSelectBlik()
    func didSelectMenu()
    func getBiometryTypeAvailable() -> BiometryTypeEntity
    func setAllowLoginBlockedUsers()
}

final class PLRememberedLoginPinPresenter {
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLRememberedLoginPinViewControllerProtocol?
    private let localAuth: LocalAuthenticationPermissionsManagerProtocol
    private var allowLoginBlockedUsers = false

    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.localAuth = dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
    }
}

extension PLRememberedLoginPinPresenter : PLRememberedLoginPinPresenterProtocol {
   
    func setAllowLoginBlockedUsers() {
        self.allowLoginBlockedUsers = true
    }
    
    func getBiometryTypeAvailable() -> BiometryTypeEntity {
        #if targetEnvironment(simulator)
        return .faceId
        #else
        return self.localAuth.biometryTypeAvailable
        #endif
    }
    
    func didSelectBalance() {
        
    }
    
    func didSelectBlik() {
        
    }

    func doLogin(with pin: String) {
        self.view?.showLoading()
    }
    
    func viewDidLoad() {
        
    }
    
    func viewDidAppear() {
        
    }
}

extension PLRememberedLoginPinPresenter: PLPublicMenuPresentableProtocol {
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

extension PLRememberedLoginPinPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        //No need to navigate back.
    }
    
    func handle(error: PLGenericError) {
        switch error {
        case .other(let description):
            switch description {
            case "TEMPORARY_LOCKED":
                self.view?.dismissLoading(completion: { [weak self] in
                    self?.view?.showAccountPermanentlyBlockedDialog()
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
