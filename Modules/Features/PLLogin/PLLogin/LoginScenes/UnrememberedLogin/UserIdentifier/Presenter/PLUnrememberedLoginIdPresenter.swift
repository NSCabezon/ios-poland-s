//
//  PLUnrememberedLoginIdPresenter.swift
//  PLLogin

import CoreFoundationLib
import PLCommons
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import UI

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
    
    private var unrememberedLoginProcessGroup: PLUnrememberedLoginProcessGroup {
        self.dependenciesResolver.resolve(for: PLUnrememberedLoginProcessGroup.self)
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
    
    private lazy var loginPullOfferLoader: PLLoginPullOfferLoader = {
        return self.dependenciesResolver.resolve(for: PLLoginPullOfferLoader.self)
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
        self.trackScreen()
        self.loadData()
    }
    
    func viewWillAppear() {
        self.getCurrentEnvironments()
    }
    
    func login(identification: String) {
        trackEvent(.clickInitSession)
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
            guard let self = self else { return }
            
            switch type {
            case .notPersisted(let info):
                self.unrememberedLoginProcessGroup.execute(input: PLUnrememberedLoginProcessGroupInput(identification: info.identification)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let output):
                        self.loginSuccess(configuration: output.configuration)
                    case .failure(let groupError):
                        let httpErrorCode = self.getHttpErrorCode(groupError.error) ?? ""
                        self.trackEvent(.apiError, parameters: [PLLoginTrackConstants.errorCode : httpErrorCode, PLLoginTrackConstants.errorDescription : groupError.error.getErrorDesc() ?? ""])
                        self.handleError(groupError.error)
                    }
                }
            default:
                break
            }
        })
    }
    
    func getCurrentEnvironments() {
        Scenario(useCase: self.getPLCurrentEnvironmentUseCase).execute(on: self.dependenciesResolver.resolve())
        .onSuccess( { [weak self] result in
            self?.didLoadEnvironment(result.bsanEnvironment, publicFilesEnvironment: result.publicFilesEnvironment)
        })
    }
    
    func chooseEnvironment() {
        self.publicFilesManager.loadPublicFiles(withStrategy: .reload, timeout: 5)
        self.getCurrentEnvironments()
    }
    
    func loadData() {
        self.publicFilesManager.add(subscriptor: PLUnrememberedLoginIdPresenter.self) { [weak self] in
            self?.loginPullOfferLoader.loadPullOffers()
        }
    }
    
    func loginSuccess(configuration: UnrememberedLoginConfiguration) {

        let time = Date(timeIntervalSince1970: configuration.unblockRemainingTimeInSecs ?? 0)
        let now = Date()
        
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            if configuration.isFinal() {
                self.trackEvent(.info, parameters: [PLLoginTrackConstants.errorCode: "1000", PLLoginTrackConstants.errorDescription: localized("pl_login_alert_attemptLast")])
                self.view?.showInvalidSCADialog {
                    self.goToPasswordScene(configuration)
                }
            } else if self.allowLoginBlockedUsers {
                self.goToPasswordScene(configuration)
            } else if configuration.isBlocked() && time > now {
                self.trackEvent(.userTemporarilyBlocked)
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
                self.trackEvent(.userPermanentlyBlocked)
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

extension PLUnrememberedLoginIdPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLUnrememberedLoginPage {
        return PLUnrememberedLoginPage()
    }
}
