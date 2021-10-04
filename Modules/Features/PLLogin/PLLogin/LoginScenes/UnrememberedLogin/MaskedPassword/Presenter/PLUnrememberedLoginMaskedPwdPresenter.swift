//
//  PLUnrememberedLoginMaskedPwdPresenter.swift
//  PLLogin

import DomainCommon
import Commons
import PLCommons
import Models
import LoginCommon
import SANPLLibrary
import PLLegacyAdapter
import PLUI

protocol PLUnrememberedLoginMaskedPwdPresenterProtocol: MenuTextWrapperProtocol, PLPublicMenuPresentableProtocol {
    var view: PLUnrememberedLoginMaskedPwdViewProtocol? { get set }
    func login(password: String)
    func viewDidLoad()
    func requestedPositions() -> [Int]
}

final class PLUnrememberedLoginMaskedPwdPresenter {
    weak var view: PLUnrememberedLoginMaskedPwdViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    private var publicFilesEnvironment: PublicFilesEnvironmentEntity?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLUnrememberedLoginMaskedPwdPresenterProtocol {
    func viewDidLoad() {
        self.view?.setUserIdentifier(loginConfiguration.displayUserIdentifier)

        if let imageString = loginConfiguration.loginImageData,
           let data = Data(base64Encoded: imageString),
           let image = UIImage(data: data) {
            self.view?.setUserImage(image: image)
        }
    }
    
    func login(password: String) {
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

    /// Returns [Int] with the positions requested for the masked password
    func requestedPositions() -> [Int] {

        var maskValue: Int = 0
        if case .masked(mask: let value) = self.loginConfiguration.passwordType {
            maskValue = value + 1048576
        }

        let binaryString = String(maskValue, radix: 2).reversed()
        var pos = 0
        let requestedPositions: [Int] = binaryString.compactMap {
            let value = Int(String($0)) ?? 0
            pos += 1
            guard pos <= 20 else { return nil }
            return value == 1 ? pos : nil
        }
        return requestedPositions
    }
    
    func didSelectMenu() {
        self.coordinatorDelegate.didSelectMenu()
    }
}

extension PLUnrememberedLoginMaskedPwdPresenter: PLLoginPresenterErrorHandlerProtocol {

    var associatedErrorView: PLGenericErrorPresentableCapable? {
        return self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.coordinator.goBackToLogin()
    }
}

//MARK: - Private Methods
private extension  PLUnrememberedLoginMaskedPwdPresenter {
    var coordinator: PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLUnrememberedLoginMaskedPwdCoordinatorProtocol.self)
    }
    
    var coordinatorDelegate: LoginCoordinatorDelegate {
        return self.dependenciesResolver.resolve(for: LoginCoordinatorDelegate.self)
    }
}
