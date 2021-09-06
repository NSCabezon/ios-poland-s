//
//  PLLoginPresenterErrorHandlerProtocol.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 4/8/21.
//

import Foundation
import Commons
import PLCommons
import SANPLLibrary

public protocol PLLoginPresenterErrorHandlerProtocol: PLGenericErrorPresenterLayerProtocol {
    func handleError(_ error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>)
}

extension PLLoginPresenterErrorHandlerProtocol {
    func handleError(_ error: UseCaseError<PLUseCaseErrorOutput<LoginErrorType>>) {
        switch error {
        case .error(let err):
            guard let loginError = err?.error else {
                self.handle(error: err?.genericError ?? .unknown)
                return
            }
        
            switch loginError {
            case .unauthorized:
                self.handle(error: .unauthorized)
            case .emptyPass:
                self.associatedErrorView?.presentError(("pl_onboarding_alert_genFailedTitle",
                                                        "login_popup_passwordRequired"), completion: {
                    otherErrorPresentedWith(error: loginError)
                })
            case .temporaryLocked:
                self.handle(error: .other("TEMPORARY_LOCKED"))
            case .versionBlocked(let description):
                self.handle(error: .other(description))
            default:
                self.handle(error: .applicationNotWorking)
            }
        case .networkUnavailable:
            self.handle(error: .noConnection)
        default:
            self.handle(error: .applicationNotWorking)
        }
    }
}
