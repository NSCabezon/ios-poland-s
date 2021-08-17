//
//  PLTrustedDeviceSmsAuthPresenter.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//
import Models
import Commons
import PLCommons
import SANPLLibrary

protocol PLTrustedDeviceSmsAuthPresenterProtocol: MenuTextWrapperProtocol {
    var view: PLTrustedDeviceSmsAuthViewProtocol? { get set }
    func viewDidLoad()
    func goBack()
    func authenticate(smsCode: String)
}

final class PLTrustedDeviceSmsAuthPresenter: PLTrustedDeviceSmsAuthPresenterProtocol {
    
    internal let dependenciesResolver: DependenciesResolver
    weak var view: PLTrustedDeviceSmsAuthViewProtocol?
    
    var deviceConfiguration: TrustedDeviceConfiguration {
        return self.dependenciesResolver.resolve(for: TrustedDeviceConfiguration.self)
    }
    
    private var loginConfiguration: UnrememberedLoginConfiguration {
        self.dependenciesResolver.resolve(for: UnrememberedLoginConfiguration.self)
    }
    
    var confirmationCodeRegisterUseCase: PLConfirmationCodeRegisterUseCase {
        self.dependenciesResolver.resolve(for: PLConfirmationCodeRegisterUseCase.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func viewDidLoad() {
        requestSMSConfirmationCode()
    }
    
    func goBack() {
        // TODO: implement navigate back to device trust pin
    }
    
    func authenticate(smsCode: String) {
        
    }
    
    func requestSMSConfirmationCode() {
        guard let deviceId = deviceConfiguration.deviceData?.deviceId else {
            self.handleError(UseCaseError.error(PLUseCaseErrorOutput<LoginErrorType>(error: .emptyField)))
            return
        }
        guard let challenge = calculateSecondFactorSmsChallenge() else {
            self.handle(error: .unauthorized)
            return
        }
        let input = PLPLConfirmationCodeRegisterInput(trustedDeviceId: deviceId,
                                                      secondFactorSmsChallenge: challenge,
                                                      language: getLanguage())
        Scenario(useCase: confirmationCodeRegisterUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess({ _ in
                //SMS sended
            }).onError({ [weak self] error in
                self?.handleError(error)
            })
    }
}

private extension PLTrustedDeviceSmsAuthPresenter {
    func getLanguage() -> String {
        return dependenciesResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType.rawValue ?? "en"
    }
    
    func calculateSecondFactorSmsChallenge() -> String? {
        guard let ivrCode = deviceConfiguration.ivrInputCode else { return nil }
        guard let deviceId = deviceConfiguration.deviceData?.deviceId else { return nil }
        guard let deviceTime = deviceConfiguration.deviceData?.deviceTime else { return nil }
        guard let tokens = deviceConfiguration.tokens else { return nil }

        let userId = Int(loginConfiguration.userIdentifier) ?? 0
        var challenge: String = ""
        
        tokens.forEach({ token in
            challenge = challenge + getChallengeFor(tokenId: token.id,
                                                    tokenTimeStamp: token.timestamp,
                                                    id: userId) + "|"
        })
        challenge = challenge + getChallengeFor(tokenId: Int(deviceId) ?? 0,
                                                tokenTimeStamp: Int(deviceTime) ?? 0,
                                                id: userId)
        challenge = String(format: "%@|%d", challenge, ivrCode)
        return hashChallenge(challenge)
    }
    
    func getChallengeFor(tokenId: Int, tokenTimeStamp: Int , id: Int) -> String {
        return(String(format: "%08d-%010d-%010d",id, tokenId, tokenTimeStamp))
    }
    
    func hashChallenge(_ challenge: String) -> String {
        var challengeNumber:Int64 = 0
        var blockChallengeNumber:Int64 = 0
        let challengeUC:String = challenge.uppercased()
        var j:Int = 0
        for i in 0...(challengeUC.count-1) {
            let c = challengeUC[challengeUC.index(challengeUC.startIndex, offsetBy: i)]
            if c.isNumber || c.isLetter {
                if (j % 8) == 0 {
                    challengeNumber += blockChallengeNumber
                    blockChallengeNumber = 0
                }
                blockChallengeNumber *= 10
                if c.isNumber, let asciiVal = c.asciiValue {
                    let zero = Int64(("0" as Character).asciiValue ?? 0)
                    blockChallengeNumber += Int64(asciiVal) - zero
                } else if let asciiVal = c.asciiValue {
                    let capitalA = Int64(("A" as Character).asciiValue ?? 0)
                    blockChallengeNumber += (Int64(asciiVal) - capitalA) % 10
                }
                j += 1
            }
        }
        challengeNumber += blockChallengeNumber
        challengeNumber &= 4294967295
        return String(format: "%d", challengeNumber % 100000000)
    }
}

extension PLTrustedDeviceSmsAuthPresenter: PLLoginPresenterErrorHandlerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? {
        self.view
    }
    
    func genericErrorPresentedWith(error: PLGenericError) {
        self.goBack()
    }
}