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
        case .error(let error):
            if error?.error == nil {
                self.handle(error: error?.genericError ?? .unknown)
            } else {
                self.handle(error: .applicationNotWorking)
            }
        case .networkUnavailable:
            self.handle(error: .noConnection)
        default:
            self.handle(error: .applicationNotWorking)
        }
    }
}
