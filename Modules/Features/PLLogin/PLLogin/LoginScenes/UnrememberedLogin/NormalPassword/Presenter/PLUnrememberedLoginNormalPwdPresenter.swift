//
//  PLUnrememberedLoginNormalPwdPresenter.swift
//  PLLogin

import CoreFoundationLib
import Commons
import PLCommons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter

protocol PLUnrememberedLoginNormalPwdPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLUnrememberedLoginNormalPwdViewProtocol? { get set }
    func login(password: String)
    func viewDidLoad()
}

final class PLUnrememberedLoginNormalPwdPresenter {
    weak var view: PLUnrememberedLoginNormalPwdViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
}

extension PLUnrememberedLoginNormalPwdPresenter: PLUnrememberedLoginNormalPwdPresenterProtocol {

    func login(password: String) {
        self.trackEvent(.clickInitSession)
        self.loginConfiguration.password = password
        
        switch self.loginConfiguration.challenge.authorizationType {
        case .sms:
            self.coordinator.goToSMSScene()
        case .tokenTime, .tokenTimeCR:
            self.coordinator.goToHardwareTokenScene()
        case .softwareToken:
            self.handle(error: .applicationNotWorking)
        }        
    }

    func viewDidLoad() {
        let image: Bool = loginConfiguration.loginImageData != nil
        self.trackerManager.trackScreen(screenId: PLUnrememberedLoginNormalPasswordPage().page, extraParameters: [PLLoginTrackConstants.trustedImage: String(image), PLLoginTrackConstants.referer : PLUnrememberedLoginPage().page])

        self.view?.setUserIdentifier(loginConfiguration.displayUserIdentifier)

        if let imageString = loginConfiguration.loginImageData,
           let data = Data(base64Encoded: imageString),
           let image = UIImage(data: data) {
            self.view?.setUserImage(image: image)
        }
    }

    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

extension PLUnrememberedLoginNormalPwdPresenter: PLLoginPresenterErrorHandlerProtocol {

    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return self.view
    }

    func genericErrorPresentedWith(error: PLGenericError) {
        self.coordinator.goBackToLogin()
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginNormalPwdPresenter {
    var coordinator: PLUnrememberedLoginNormalPwdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginNormalPwdCoordinatorProtocol.self)
    }
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }
}

extension PLUnrememberedLoginNormalPwdPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: PLUnrememberedLoginNormalPasswordPage {
        return PLUnrememberedLoginNormalPasswordPage()
    }
}
