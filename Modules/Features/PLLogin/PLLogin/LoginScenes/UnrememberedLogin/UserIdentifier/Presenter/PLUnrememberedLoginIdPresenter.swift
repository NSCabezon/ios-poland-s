//
//  PLUnrememberedLoginIdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import PLCommons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import UI
import Repository

protocol PLUnrememberedLoginIdPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLUnrememberedLoginIdViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String)
    func didSelectChooseEnvironment()
    func goToPasswordScene(_ configuration: UnrememberedLoginConfiguration)
    func openAppStore()
}

final class PLUnrememberedLoginIdPresenter {
    weak var view: PLUnrememberedLoginIdViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var loginProcessUseCase: PLLoginProcessUseCase {
        self.dependenciesResolver.resolve(for: PLLoginProcessUseCase.self)
    }
    
    private var validateVersionUseCase: PLValidateVersionUseCase {
        self.dependenciesResolver.resolve(for: PLValidateVersionUseCase.self)
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
    
    private var getPLCurrentEnvironmentUseCase: GetPLCurrentEnvironmentUseCase {
        self.dependenciesResolver.resolve(for: GetPLCurrentEnvironmentUseCase.self)
    }
    
    private var publicFilesManager: PublicFilesManagerProtocol {
        return self.dependenciesResolver.resolve(for: PublicFilesManagerProtocol.self)
    }
    
    private lazy var loginPLPullOfferLayer: LoginPLPullOfferLayer = {
        return self.dependenciesResolver.resolve(for: LoginPLPullOfferLayer.self)
    }()
    
    private lazy var appStoreNavigator: PLAppStoreNavigator = {
        return PLAppStoreNavigator()
    }()
        
    deinit {
        self.publicFilesManager.remove(subscriptor: PLUnrememberedLoginIdPresenter.self)
    }
}

extension PLUnrememberedLoginIdPresenter: PLUnrememberedLoginIdPresenterProtocol {
    func viewDidLoad() {
        self.loadData()
    }
    
    func viewWillAppear() {
        self.getCurrentEnvironments()
    }
    
    func login(identification: String) {
        self.publicFilesManager.cancelPublicFilesLoad(withStrategy: .initialLoad)
        self.doLogin(with: .notPersisted(info: LoginTypeInfo(identification: identification)))
    }
    
    func didSelectChooseEnvironment() {
        self.coordinatorDelegate.goToEnvironmentsSelector { [weak self] in
            self?.chooseEnvironment()
        }
    }

    func goToPasswordScene(_ configuration: UnrememberedLoginConfiguration) {
        switch configuration.passwordType {
        case .normal:
            self.coordinator.goToNormalPasswordScene(configuration: configuration)
        case .masked:
            self.coordinator.goToMaskedPasswordScene(configuration: configuration)
        }
    }
    
    func openAppStore() {
        appStoreNavigator.openAppStore()
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginIdPresenter {
    
    var coordinator: PLUnrememberedLoginIdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginIdCoordinatorProtocol.self)
    }
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }

    func doLogin(with type: LoginType) {
        let loadingText = LoadingText(title: localized("login_popup_identifiedUser"),
                                      subtitle: localized("loading_label_moment"))
        self.view?.showLoadingWith(loadingText: loadingText, completion: { [weak self] in
            
            switch type {
            case .notPersisted(let info):
                self?.loginProcessUseCase.executeNonPersistedLogin(type: type,
                                                                   identification: info.identification) { [weak self] config in
                    guard let config = config else {
                        self?.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
                        return
                    }
                    self?.loginSuccess(configuration: config)
                } onFailure: { [weak self]  error in
                    self?.handleError(error)
                }
            default:
                break
            }
        })
    }
    
    func getCurrentEnvironments() {
        MainThreadUseCaseWrapper(
            with: self.getPLCurrentEnvironmentUseCase,
            onSuccess: { [weak self] result in
                self?.didLoadEnvironment(result.bsanEnvironment,
                                         publicFilesEnvironment: result.publicFilesEnvironment)
        })
    }
    
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        self.getCurrentEnvironments()
    }
    
    func loadData() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .initialLoad, timeout: 0)
        self.publicFilesManager.add(subscriptor: PLUnrememberedLoginIdPresenter.self) { [weak self] in
            self?.loginPLPullOfferLayer.loadPullOffers()
            self?.checkValidVersion()
        }
    }
    
    func loginSuccess(configuration: UnrememberedLoginConfiguration) {
        self.view?.dismissLoading(completion: { [weak self] in
            if configuration.isFinal() {
                self?.view?.showInvalidSCADialog {
                    self?.goToPasswordScene(configuration)
                }
            } else if configuration.isBlocked() {
                self?.view?.showAccountTemporaryBlockedDialog(configuration)
            } else {
                self?.goToPasswordScene(configuration)
            }
        })
    }
    
    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
    }
    
    func checkValidVersion() {
        Scenario(useCase: validateVersionUseCase).execute(on: self.dependenciesResolver.resolve())
        .onError({[weak self] error in
            self?.handleError(error)
        })
    }
}

extension PLUnrememberedLoginIdPresenter: PLLoginPresenterErrorHandlerProtocol {
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
            case "DEPRECATED_VERSION":
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
