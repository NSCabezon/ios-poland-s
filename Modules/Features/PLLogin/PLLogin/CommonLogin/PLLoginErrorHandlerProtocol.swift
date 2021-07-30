//
//  PLLoginErrorHandlerProtocol.swift
//  Account
//
//  Created by Mario Rosales Maillo on 23/7/21.
//

import Foundation
import Commons
import PLCommons
import SANPLLibrary

public protocol PLLoginErrorHandlerProtocol {
    func handle(error: NetworkProviderError) -> PLUseCaseErrorOutput<LoginErrorType>
}

public extension PLLoginErrorHandlerProtocol {
    
    func handle(error: NetworkProviderError) -> PLUseCaseErrorOutput<LoginErrorType> {
        
        switch error {
        case .noConnection:
            return PLUseCaseErrorOutput(genericError: .noConnection)
        case .unauthorized, .otpExpired:
            return PLUseCaseErrorOutput(error: .unauthorized)
        case .other:
            return PLUseCaseErrorOutput(genericError: .applicationNotWorking)
        case .error(_):
            switch error.getErrorCode() {
            case 500, 510:
                return PLUseCaseErrorOutput(genericError: .applicationNotWorking)
            case 401, 403:
                return PLUseCaseErrorOutput(error: .unauthorized)
            default:
                return PLUseCaseErrorOutput(genericError: .unknown)
            }
        }
    }
}
