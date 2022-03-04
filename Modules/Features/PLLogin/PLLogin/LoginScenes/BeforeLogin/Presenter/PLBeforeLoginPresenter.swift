//
//  PLBeforeLoginPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import Foundation
import CoreFoundationLib
import LoginCommon
import PLCommons
import PLCommonOperatives
import UI

public enum PLRememberedLoginBackgroundType {
    case assets(name: String)
    case documents(data: Data?)
}

protocol PLBeforeLoginPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLBeforeLoginViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewDidAppear()
    func viewWillDisappear()
    func openAppStore()
}

final class PLBeforeLoginPresenter {
    weak var view: PLBeforeLoginViewControllerProtocol?
    internal let dependenciesResolver: DependenciesResolver
    var isDeprecatedVersion:Bool = false
    var isMaintenance:Bool = false

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
    
    private var getUserPreferencesUseCase: PLGetUserPreferencesUseCase {
        self.dependenciesResolver.resolve(for: PLGetUserPreferencesUseCase.self)
    }
    
    private var setDemoUserUseCase: PLSetDemoUserUseCase {
        return PLSetDemoUserUseCase(dependenciesResolver: self.dependenciesResolver)
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
        var configuration = RememberedLoginConfiguration(userIdentifier: "")
        Scenario(useCase: validateVersionUseCase).execute(on: self.dependenciesResolver.resolve())
        .then(scenario: { [weak self] _ -> Scenario<Void, PLGetUserPrefEntityUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
            guard let self = self else { return nil }
            return Scenario(useCase: self.getUserPreferencesUseCase)
        })
        .then(scenario: { [weak self] result -> Scenario<PLSetDemoUserUseCaseInput, PLSetDemoUserUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
            guard let self = self else { return nil }
                
            if let userId = result.userId {
                configuration = RememberedLoginConfiguration(userIdentifier: userId)
            }
            configuration.userPref = RememberedLoginUserPreferencesConfiguration(name: result.name,
                                                                                 theme: result.theme,
                                                                                 biometricsEnabled: result.biometricsEnabled)
            TimeImageAndGreetingViewModel.shared.setThemeType(result.theme, resolver: self.dependenciesResolver)
            self.view?.imageReady()
            let caseInput = PLSetDemoUserUseCaseInput(userId: result.login ?? "")
            return Scenario(useCase: self.setDemoUserUseCase, input: caseInput)
        })
        .then(scenario: { [weak self] output -> Scenario<Void, PLBeforeLoginUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
            guard let self = self else { return nil }
            if output.isDemoUser {
                configuration.userIdentifier = output.userId
                configuration.isDemoUser = true
            }
            return Scenario(useCase: self.beforeLoginUseCase)
        })
        .onSuccess({ [weak self] result in
            guard let self = self else { return }
            self.isMaintenance = false
            if configuration.userIdentifier == "" {
                configuration.userIdentifier = String(result.userId)
            }
            configuration.isBiometricsAvailable = result.isBiometricsAvailable
            configuration.isPinAvailable = result.isPinAvailable
            self.navigate(configuration: configuration)
        })
        .onError({[weak self] error in
            self?.view?.loadDidFinish()            
            if case .error(let err) = error {
                if err?.genericError == .maintenance {
                    self?.showMaintenanceWebView()
                    return
                }
            }
            self?.handleError(error)
            
        })
    }
}

extension PLBeforeLoginPresenter: PLBeforeLoginPresenterProtocol {
    func viewWillDisappear() {
        self.publicFilesManager.remove(subscriptor: PLBeforeLoginPresenter.self)
    }
    
    func viewDidAppear() {
        guard isDeprecatedVersion || isMaintenance else { return }
        self.validateVersionAndUser()
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func navigate(configuration: RememberedLoginConfiguration) {
        self.view?.loadDidFinish()
        if configuration.isPinAvailable {
            self.coordinator.loadRememberedLogin(configuration: configuration)
        } else {
            self.coordinator.loadUnrememberedLogin()
        }
    }
    
    func openAppStore() {
        guard let viewController = self.view as? UIViewController else { return }
        appStoreNavigator.openAppStore(presenterViewController: viewController)
    }
    
    func showMaintenanceWebView(){
        isMaintenance = true
        let webViewCoordinator = self.dependenciesResolver.resolve(for: PLWebViewCoordinatorDelegate.self)
        let configuration = BasePLWebConfiguration(
            initialURL: "https://www.centrum24.pl/przerwa/mobile_sa_zaslepka.html",
            httpMethod: .get,
            bodyParameters: [:],
            closingURLs: ["app://close"],
            webToolbarTitleKey: nil,
            pdfToolbarTitleKey: nil,
            isFullScreenEnabled: false,
            showRightCloseNavigationItem: true,
            showBackNavigationItem: false
        )
        let handler = PLWebviewCustomLinkHandler(configuration: configuration)
        webViewCoordinator.showWebView(handler: handler)
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
