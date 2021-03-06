//
//  PLAuthorizationPresenter.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 25/10/21.
//

import CoreFoundationLib
import LocalAuthentication
import PLCommons
import SecurityExtensions
import CoreDomain

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
    func updateRemainingProgressTime(_ time: Float?)
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
    private var progressTotalTime: Float?

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
    
    private var getCertificateUseCase: PLGetSecIdentityUseCase<StringErrorOutput> {
        self.dependenciesResolver.resolve(for: PLGetSecIdentityUseCase<StringErrorOutput>.self)
    }
    
    private var getStoredUserKey: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<StringErrorOutput> {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase<StringErrorOutput>.self)
    }
    
    private var getStoredTrustedDeviceHeaders: PLTrustedDeviceGetHeadersUseCase<StringErrorOutput> {
        self.dependenciesResolver.resolve(for: PLTrustedDeviceGetHeadersUseCase<StringErrorOutput>.self)
    }
    
    private var authorizationDataEncryptionUseCase: PLAuthorizationDataEncryptionUseCase<StringErrorOutput> {
        self.dependenciesResolver.resolve(for: PLAuthorizationDataEncryptionUseCase<StringErrorOutput>.self)
    }
}

private extension PLAuthorizationPresenter {
    func evaluateBiometryAccess() {
        let type = self.localAuthentication.biometryTypeAvailable
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
        self.confirmPin(accessType: .biometrics)
    }
    
    func onBiometryError(_ error: Error? = nil) {
        self.showGenericError()
    }
}

private extension PLAuthorizationPresenter {
    func showGenericError() {
        self.showError("sendMoney_title_somethingIsWrong", textKey: "sendMoney_text_somethingIsWrong")
    }
    
    func showError(_ titleKey: String, textKey: String) {
        let viewModel = BottomSheetErrorViewModel(imageKey: "oneIcnAlert",
                                                  titleKey: titleKey,
                                                  textKey: textKey,
                                                  mainButtonKey: "generic_link_ok")
        self.view?.showGenericError(viewModel)
    }
}

extension PLAuthorizationPresenter: PLAuthorizationPresenterProtocol {
    func viewDidLoad() {
        let remainingTimeViewModel = RemainingTimeViewModel(totalTime: progressTotalTime ?? Constants.totalTime)
        self.view?.addRemainingTimeView(remainingTimeViewModel)
        self.view?.addInputSignatureView()
        self.shouldShowBiometryView { [weak self] showBiometry in
            if showBiometry {
                self?.addInputBiometryView()
            }
        }
    }
    
    func addInputBiometryView() {
        let biometryAvailable = self.localAuthentication.biometryTypeAvailable
        switch biometryAvailable {
        case .error(biometry: _, error: _), .none: return
        case .faceId, .touchId:
            let viewModel = InputBiometricsViewModel(biometryType: biometryAvailable)
            self.view?.addInputBiometricsView(viewModel)
        }
    }
    
    func updateRemainingProgressTime(_ time: Float?) {
        progressTotalTime = time
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
        self.confirmPin(accessType: .pin(value: self.pin ?? ""))
    }
    
    func didTimerEnd() {
        self.showError("sendMoney_title_timeIsOver", textKey: "sendMoney_text_timeIsOver")
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

    func shouldShowBiometryView(completion: @escaping (Bool) -> Void) {
        Scenario(useCase: self.getStoredUserKey)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { output in
                completion(output.encryptedUserKeyBiometrics?.count ?? 0 > 0)
            }
    }
    
    func getRandomKey(_ accessType: AccessType?) {
        guard let remembered = accessType else {
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
    
    func confirmPin(accessType: AccessType?) {
        var encryptedStoredUserKey: String?
        var identity: SecIdentity?
        let input = PLGetSecIdentityUseCaseInput(label: "PLCertificateIdentity")
        self.getRandomKey(accessType)
        Scenario(useCase: self.getCertificateUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetStoredEncryptedUserKeyUseCaseOutput, PLUseCaseErrorOutput<StringErrorOutput>>? in
                guard let self = self else { return nil }
                identity = output.secIdentity
                return Scenario(useCase: self.getStoredUserKey)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PLTrustedDeviceGetHeadersUseCaseOutput, PLUseCaseErrorOutput<StringErrorOutput>>? in
                guard let self = self else { return nil }
                switch accessType {
                case .pin(value: _), .none:
                    encryptedStoredUserKey = output.encryptedUserKeyPIN
                case .biometrics:
                    encryptedStoredUserKey = output.encryptedUserKeyBiometrics
                }
                return Scenario(useCase: self.getStoredTrustedDeviceHeaders)
            })
            .then(scenario: { [weak self] output ->Scenario<PLAuthorizationDataEncryptionUseCaseInput, PLAuthorizationDataEncryptionUseCaseOutput, PLUseCaseErrorOutput<StringErrorOutput>>? in
                guard let self = self,
                      let privateKey = identity?.privateKey,
                      let encryptedStoredUserKey = encryptedStoredUserKey,
                      let appId = output.appId
                else { return nil }
                let caseInput = PLAuthorizationDataEncryptionUseCaseInput(appId: appId,
                                                                               pin: self.pin,
                                                                               encryptedUserKey: encryptedStoredUserKey,
                                                                               randomKey: self.randomKey ?? "",
                                                                               challenge: self.configuration.challenge,
                                                                               privateKey: privateKey)
                return Scenario(useCase: self.authorizationDataEncryptionUseCase, input: caseInput)
            })
            
            .then(scenario: { [weak self] output ->Scenario<ConfirmPinUseCaseInput, ConfirmPinUseCaseOkOutput, PLUseCaseErrorOutput<StringErrorOutput>>? in
                guard let self = self, let certificate = identity?.PEMFormattedCertificate() else { return nil }
                let caseInput = ConfirmPinUseCaseInput(authorizationId: self.configuration.authorizationId,
                                                       softwareTokenType: self.softwareTokenType ?? "",
                                                       trustedDeviceCertificate: certificate,
                                                       authorizationData: output.encryptedAuthorizationData)
                return Scenario(useCase: self.confirmPinUseCase, input: caseInput)
            })
            .onSuccess { representable in
                self.view?.endTimer()
                self.configuration.completion(.handled(representable))
            }
            .onError { _ in
                self.showGenericError()
            }
    }
}
