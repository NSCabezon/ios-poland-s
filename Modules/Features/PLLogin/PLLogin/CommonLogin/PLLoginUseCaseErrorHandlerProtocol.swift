//
//  PLLoginUseCaseErrorHandlerProtocol.swift
//  Account
//
//  Created by Mario Rosales Maillo on 23/7/21.
//

import Foundation
import Commons
import PLCommons
import SANPLLibrary

public protocol PLLoginUseCaseErrorHandlerProtocol {
    func handle(error: NetworkProviderError) -> PLUseCaseErrorOutput<LoginErrorType>
}

public extension PLLoginUseCaseErrorHandlerProtocol {

    func handle(error: NetworkProviderError) -> PLUseCaseErrorOutput<LoginErrorType> {
        switch error {
        case .noConnection:
            return PLUseCaseErrorOutput(genericError: .noConnection, httpErrorCode: error.getErrorCode())
        case .unauthorized:
            return PLUseCaseErrorOutput(error: .unauthorized, httpErrorCode: error.getErrorCode())
        case .unprocessableEntity:
            return PLUseCaseErrorOutput(genericError: .other("UNPROCESSABLE_ENTITY"), httpErrorCode: error.getErrorCode())
        case .other:
            return PLUseCaseErrorOutput(genericError: .applicationNotWorking, httpErrorCode: error.getErrorCode())
        case .error(let err):
            switch error.getErrorCode() {
            case 500, 510:
                return PLUseCaseErrorOutput(genericError: .applicationNotWorking, httpErrorCode: error.getErrorCode())
            case 401, 403:
                return PLUseCaseErrorOutput(error: .unauthorized, httpErrorCode: error.getErrorCode())
            default:
                let detail = err.getErrorDetail()
                switch detail?.errorCode {
                case "UNAUTHORIZED_GRANT":
                    return PLUseCaseErrorOutput(error: .unauthorized, httpErrorCode: error.getErrorCode())
                case "SERVER_ERROR":
                    return PLUseCaseErrorOutput(error: .serviceFault, httpErrorCode: error.getErrorCode())
                case .none:
                    return PLUseCaseErrorOutput(genericError: .unknown, httpErrorCode: error.getErrorCode())
                default:
                    return PLUseCaseErrorOutput(genericError: .unknown, httpErrorCode: error.getErrorCode())
                }
            }
        }
    }
}
