//
//  PLUseCaseErrorOutput.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import CoreFoundationLib

public class PLUseCaseErrorOutput<T>: StringErrorOutput {
    public var genericError: PLGenericError = .unknown
    public var error: T?
    public var httpErrorCode: Int?
    
    public init(genericError: PLGenericError? = nil, httpErrorCode: Int? = nil) {
        let genError = genericError ?? .unknown
        self.genericError = genError
        self.httpErrorCode = httpErrorCode
        super.init(genError.rawValue)
    }
    
    public init(errorDescription: String, httpErrorCode: Int? = nil) {
        self.httpErrorCode = httpErrorCode
        super.init(errorDescription)
    }
    
    public convenience init(error: T, httpErrorCode: Int? = nil) {
        self.init(httpErrorCode: httpErrorCode)
        self.error = error
    }
    
    public func getError() -> T? {
        return self.error
    }
}
