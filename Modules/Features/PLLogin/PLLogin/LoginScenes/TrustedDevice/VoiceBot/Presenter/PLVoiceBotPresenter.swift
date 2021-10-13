//
//  VoiceBotPresenter.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import Models
import Commons
import PLCommons
import SANPLLibrary
import os

protocol PLVoiceBotPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLVoiceBotViewProtocol? { get set }
    func viewDidLoad()
    func getDevices()
    func setIvrOutputcode(code: Int)
    func requestIVRCall()
    func goBack()
}

final class PLVoiceBotPresenter {
    weak var view: PLVoiceBotViewProtocol?
    internal let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension PLVoiceBotPresenter {
    var coordinator: PLVoiceBotCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: PLVoiceBotCoordinatorProtocol.self)
    }
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
    
    var ivrRegisterUseCase: PLIvrRegisterUseCase {
        self.dependenciesResolver.resolve(for: PLIvrRegisterUseCase.self)
    }
    
    var devicesUseCase: PLDevicesUseCase {
        self.dependenciesResolver.resolve(for: PLDevicesUseCase.self)
    }
}

extension PLVoiceBotPresenter: PLVoiceBotPresenterProtocol {
    
    func setIvrOutputcode(code: Int) {
        self.deviceConfiguration.ivrOutputCode = code
    }
    
    func viewDidLoad() {
        guard let ivrInputCode = deviceConfiguration.trustedDevice?.ivrInputCode else { return }
        self.view?.setIvrInputCode(ivrInputCode)
    }
    
    func getDevices() {
        self.view?.showLoading(title: localized("generic_popup_loading"),
                               subTitle: localized("loading_label_moment"),
                               completion: nil)
        
        Scenario(useCase: devicesUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ [weak self] output in
                guard let self = self else { return }
                do {
                    let challenge = try self.getChallenge(from: output.defaultAuthorizationType,
                                                          allowedAuthTypes: output.allowedAuthorizationTypes)
                    if challenge == .sms {
                        self.goToSmsAuthScreen()
                    } else if (challenge == .tokenTime || challenge == .tokenTimeCR) {
                        self.goToHardwareTokenAuthScreen()
                    } else {
                        self.handle(error: .applicationNotWorking)
                    }
                } catch {
                    self.handle(error: .applicationNotWorking)
                }
            }).onError({[weak self] error in
                self?.handleError(error)
            })
    }
    
    func requestIVRCall() {
        guard let trustedDeviceId = self.deviceConfiguration.trustedDevice?.trustedDeviceId else {
            self.handle(error: .unknown)
            return
        }
        let input = PLIvrRegisterUseCaseInput(trustedDeviceId: String(trustedDeviceId))
        self.view?.showLoading(completion: { [weak self] in
            guard let self = self else { return }
            Scenario(useCase: self.ivrRegisterUseCase, input: input)
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess({ [weak self] code in
                    self?.view?.dismissLoading(completion: { [weak self] in
                        self?.view?.showIVCCallSendedDialog(code: code)
                    })
                }).onError({ [weak self] error in
                    self?.handleError(error)
                })
        })
    }

    func goBack() {
        self.coordinator.goBack()
    }
}

extension PLVoiceBotPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.coordinator.goBack()
    }
}

private extension PLVoiceBotPresenter {

    func goToSmsAuthScreen() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToSmsAuth()
        })
    }
    
    func goToHardwareTokenAuthScreen() {
        self.view?.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            self.coordinator.goToHardwareToken()
        })
    }
    
    func getChallenge(from defaultAuthType: AuthorizationType,
                      allowedAuthTypes: [AuthorizationType]?) throws -> AuthorizationType {
        switch defaultAuthType {
        case .softwareToken:
            if let smsAuthType = allowedAuthTypes?.first(where: { $0 == .sms }) {
                return smsAuthType
            } else if let hardwareAuthType = allowedAuthTypes?.first(where: { $0 == .tokenTime || $0 == .tokenTimeCR }) {
                return hardwareAuthType
            } else {
                throw BSANException("We should have .sms, .tokenTime or .tokenTimeCR in challenges")
            }
        default:
            return defaultAuthType
        }
    }
}
