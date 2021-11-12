//
//  PLAuthorizationPresenter.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 25/10/21.
//

import Models
import Commons
import LocalAuthentication
import PLLogin
import PLCommons
import SecurityExtensions
import CoreDomain
import DomainCommon

protocol PLAuthorizationPresenterProtocol: AnyObject {
    var view: PLAuthorizationView? { get set }
    func viewDidLoad()
    func didTimerEnd()
    func didSelectBack()
    func didSelectClose()
    func didSelectContinue()
    func didTapBiometry()
    func didUpdateSignature(isInputSignatureComplete: Bool)
    func didPinChange(pin: String, isPinComplete: Bool)
}

final class PLAuthorizationPresenter {
    private struct Constants {
        static let totalTime: Float = 180
    }
    
    weak var view: PLAuthorizationView?
    private let dependenciesResolver: DependenciesResolver
    private var isEnabledTextFields = true
    private var localAuthentication: LocalAuthenticationPermissionsManagerProtocol
    private var pin: String?
    private var randomKey: String?
    private var softwareTokenType: String?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.localAuthentication = dependenciesResolver.resolve(for: LocalAuthenticationPermissionsManagerProtocol.self)
    }
    
    private var confirmPinUseCase: ConfirmPinUseCase {
        self.dependenciesResolver.resolve(for: ConfirmPinUseCase.self)
    }
    
    private var configuration: AuthorizationConfiguration {
        self.dependenciesResolver.resolve(for: AuthorizationConfiguration.self)
    }
    
    private var getCertificateUseCase: PLGetSecIdentityUseCase {
        self.dependenciesResolver.resolve(for: PLGetSecIdentityUseCase.self)
    }
    
    private var getStoredUserKey: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase.self)
    }
    
    private var getStoredTrustedDeviceHeaders: PLTrustedDeviceGetHeadersUseCase {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceGetHeadersUseCase.self)
    }
    
    private var authorizationDataEncryptionUseCase: PLLoginAuthorizationDataEncryptionUseCase {
        self.dependenciesResolver.resolve(for: PLLoginAuthorizationDataEncryptionUseCase.self)
    }
}

private extension PLAuthorizationPresenter {
    func evaluateBiometryAccess() {
        let type = self.getBiometryTypeAvailable()
        guard type != .none else {
            self.onBiometryError()
            return
        }
        let reasonKey = "pl_login_text_" + (type == .faceId ? "loginWithFaceID" : "loginWithTouchID")
        self.callBiometry(with: reasonKey)
    }
    
    func callBiometry(with reasonKey: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: localized(reasonKey)) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.onBiometrySuccess()
                    } else {
                        self?.onBiometryError(error)
                    }
                }
            }
        }
    }
    
    func onBiometrySuccess() {
        print("Biometry succeeded")
        self.confirmPin(rememberedLoginType: .Biometrics)
    }
    
    func onBiometryError(_ error: Error? = nil) {
        if let error = error {
            print("An error ocurred \(error)")
        } else {
            print("An unknown error ocurred")
        }
        self.showGenericError()
    }
    
    func getBiometryTypeAvailable() -> BiometryTypeEntity {
        return self.localAuthentication.biometryTypeAvailable
    }
}

private extension PLAuthorizationPresenter {
    func showGenericError() {
        let viewModel = BottomSheetErrorViewModel(imageKey: "oneIcnAlert",
                                                  titleKey: "sendMoney_title_somethingIsWrong",
                                                  textKey: "sendMoney_text_somethingIsWrong",
                                                  mainButtonKey: "generic_link_ok")
        self.view?.showGenericError(viewModel)
    }
}

extension PLAuthorizationPresenter: PLAuthorizationPresenterProtocol {
    func viewDidLoad() {
        let remainingTimeViewModel = RemainingTimeViewModel(totalTime: Constants.totalTime)
        self.view?.addRemainingTimeView(remainingTimeViewModel)
        self.view?.addInputSignatureView()
        self.addInputBiometryView()
    }
    
    func addInputBiometryView() {
        let biometryAvailable = self.getBiometryTypeAvailable()
        switch biometryAvailable {
        case .error(biometry: _, error: _), .none: return
        case .faceId, .touchId:
            let viewModel = InputBiometricsViewModel(biometryType: biometryAvailable)
            self.view?.addInputBiometricsView(viewModel)
        }
    }
    
    func didSelectBack() {
        self.coordinator.dismiss()
    }
    
    func didSelectClose() {
        self.coordinator.dismiss()
    }
    
    func didTapBiometry() {
        self.evaluateBiometryAccess()
    }
    
    func didSelectContinue() {
        self.confirmPin(rememberedLoginType: .Pin(value: self.pin ?? ""))
        self.coordinator.dismiss()
    }
    
    func didTimerEnd() {
        print("timer ended")
        self.showGenericError()
    }
    
    func didUpdateSignature(isInputSignatureComplete: Bool) {
        self.isEnabledTextFields = isInputSignatureComplete
    }
    
    func didPinChange(pin: String, isPinComplete: Bool) {
        self.pin = pin
        self.view?.setContinueButton(isPinComplete)
    }
}

private extension PLAuthorizationPresenter {
    var coordinator: PLAuthorizationCoordinatorProtocol {
        self.dependenciesResolver.resolve(for: PLAuthorizationCoordinatorProtocol.self)
    }
    
    func getRandomKey(_ rememberedLoginType: RememberedLoginType?) {
        guard let remembered = rememberedLoginType else {
            self.randomKey = self.configuration.softwareTokenKeys.first?.randomKey
            self.softwareTokenType = self.configuration.softwareTokenKeys.first?.softwareTokenType
            return
        }
        let type = remembered.getString()
        let softwareTokenType = configuration.softwareTokenKeys.first(where: {
            $0.softwareTokenType == type
        })
        self.randomKey = softwareTokenType?.randomKey
        self.softwareTokenType = softwareTokenType?.softwareTokenType
    }
    
    func confirmPin(rememberedLoginType: RememberedLoginType?) {
        var encryptedStoredUserKey: String?
        var identity: SecIdentity?
        let input = PLGetSecIdentityUseCaseInput(label: "PLCertificateIdentity")
        self.getRandomKey(rememberedLoginType)
        Scenario(useCase: self.getCertificateUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }

                identity = output.secIdentity
                return Scenario(useCase: self.getStoredUserKey)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                switch rememberedLoginType {
                case .Pin(value: _), .none:
                    encryptedStoredUserKey = output.encryptedUserKeyPIN
                case .Biometrics:
                    encryptedStoredUserKey = output.encryptedUserKeyBiometrics
                }
                return Scenario(useCase: self.getStoredTrustedDeviceHeaders)
            })
            .then(scenario: { [weak self] output ->Scenario<PLLoginAuthorizationDataEncryptionUseCaseInput, PLLoginAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self,
                      let privateKey = identity?.privateKey,
                      let encryptedStoredUserKey = encryptedStoredUserKey,
                      let appId = output.appId
                else { return nil }
                let caseInput = PLLoginAuthorizationDataEncryptionUseCaseInput(appId: appId,
                                                                               pin: self.pin,
                                                                               encryptedUserKey: encryptedStoredUserKey,
                                                                               randomKey: self.randomKey ?? "",
                                                                               challenge: self.configuration.challenge,
                                                                               privateKey: privateKey)
                return Scenario(useCase: self.authorizationDataEncryptionUseCase, input: caseInput)
            })
            
            .then(scenario: { [weak self] output ->Scenario<ConfirmPinUseCaseInput, ConfirmPinUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self, let certificate = identity?.PEMFormattedCertificate() else { return nil }
                let caseInput = ConfirmPinUseCaseInput(authorizationId: self.configuration.authorizationId,
                                                       softwareTokenType: self.softwareTokenType ?? "",
                                                       trustedDeviceCertificate: certificate,
                                                       authorizationData: output.encryptedAuthorizationData)
                return Scenario(useCase: self.confirmPinUseCase, input: caseInput)
            })
            .onSuccess { representable in
                self.configuration.completion(.handled(representable))
                
            }
            .onError { error in
                self.configuration.completion(.failed(error))
            }
    }
}
