//
//  CharityTransferError.swift
//  CharityTransfer
//
//  Created by 187830 on 02/12/2021.
//

import SANPLLibrary

struct CharityTransferError {
    let errorCode1: ErrorCode1
    let errorCode2: ErrorCode2
    
    enum ErrorCode1: Int, Codable {
        case customerTypeDisabled = 11
        case unknown = -1
    }
    
    enum ErrorCode2: Int, Codable {
        case pw_limit_exceeded = 17
        case pw_to_big_amount = 43
        case insufficientFunds = 725
        case unknown = -1
    }
    
    init?(with dto: PLErrorDTO?) {
        guard let dto = dto else { return nil }
        errorCode1 = ErrorCode1(rawValue: dto.errorCode1) ?? .unknown
        errorCode2 = ErrorCode2(rawValue: dto.errorCode2) ?? .unknown
    }
    
    var errorResult: AcceptCharityTransactionErrorResult {
        guard errorCode1 == .customerTypeDisabled else {
            return .generalErrorMessages
        }
        switch errorCode2 {
        case .pw_limit_exceeded, .pw_to_big_amount:
            return .limitExceeded
        case .insufficientFunds:
            return .insufficientFunds
        case .unknown:
            return .generalErrorMessages
        }
    }
}
