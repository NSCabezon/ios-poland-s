//
//  ServiceError.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//
import CoreDomain

public enum ServiceError: LocalizedErrorWithCode {
    
    case unknown
    case parsing
    case error(Error)
    case errorWithCode(LocalizedErrorWithCode)
    case timeout
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return nil
        case .error(let error):
            return error.localizedDescription
        case .errorWithCode(let error):
            return error.localizedDescription
        case .timeout:
            return nil
        case .parsing:
            return nil
        }
    }
    
    public var code: Int {
        switch self {
        case .unknown, .parsing, .error, .timeout:
            return 0
        case .errorWithCode(let error):
            return error.code
        }
    }
    
    public var errorCode: String {
        if case .errorWithCode(let error) = self {
            return error.errorCode.isEmpty ? String(self.code) : error.errorCode
        }
        return String(self.code)
    }
}
