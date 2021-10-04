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

protocol PLUnrememberedLoginIdPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLUnrememberedLoginIdViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func login(identification: String)
    func didSelectChooseEnvironment()
    func goToPasswordScene(_ configuration: UnrememberedLoginConfiguration)
    func setAllowLoginBlockedUsers()
}

final class PLUnrememberedLoginIdPresenter {
    weak var view: PLUnrememberedLoginIdViewProtocol?
    internal let dependenciesResolver: DependenciesResolver
    private var allowLoginBlockedUsers = false

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var loginProcessUseCase: PLLoginProcessUseCase {
        self.dependenciesResolver.resolve(for: PLLoginProcessUseCase.self)
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
        
    deinit {
        self.publicFilesManager.remove(subscriptor: PLUnrememberedLoginIdPresenter.self)
    }
}

extension PLUnrememberedLoginIdPresenter: PLUnrememberedLoginIdPresenterProtocol {
    
    func setAllowLoginBlockedUsers() {
        self.allowLoginBlockedUsers = true
    }
    
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
    
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }

    func goToPasswordScene(_ configuration: UnrememberedLoginConfiguration) {
        switch configuration.passwordType {
        case .normal:
            self.coordinator.goToNormalPasswordScene(configuration: configuration)
        case .masked:
            self.coordinator.goToMaskedPasswordScene(configuration: configuration)
        }
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
        self.publicFilesManager.add(subscriptor: PLUnrememberedLoginIdPresenter.self) { [weak self] in
            self?.loginPLPullOfferLayer.loadPullOffers()
        }
    }
    
    func loginSuccess(configuration: UnrememberedLoginConfiguration) {

        let time = Date(timeIntervalSince1970: configuration.unblockRemainingTimeInSecs ?? 0)
        let now = Date()
        
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            if configuration.isFinal() {
                self.view?.showInvalidSCADialog {
                    self.goToPasswordScene(configuration)
                }
            } else if self.allowLoginBlockedUsers {
                self.goToPasswordScene(configuration)
            } else if configuration.isBlocked() && time > now {
                self.view?.showAccountTemporaryBlockedDialog(configuration)
            } else {
                self.goToPasswordScene(configuration)
            }
        })
    }
    
    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity) {
        self.publicFilesEnvironment = publicFilesEnvironment
        let wsViewModel = EnvironmentViewModel(title: environment.name, url: environment.urlBase)
        let publicFilesViewModel = EnvironmentViewModel(title: publicFilesEnvironment.name, url: publicFilesEnvironment.urlBase)
        self.view?.updateEnvironmentsText([wsViewModel, publicFilesViewModel])
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
