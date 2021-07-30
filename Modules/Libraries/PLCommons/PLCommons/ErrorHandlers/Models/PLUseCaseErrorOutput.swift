//
//  PLUseCaseErrorOutput.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import DomainCommon

public class PLUseCaseErrorOutput<T>: StringErrorOutput {
    public var genericError: PLGenericError = .unknown
    public var error: T?
    
    public init(genericError: PLGenericError? = nil) {
        let genError = genericError ?? .unknown
        self.genericError = genError
        super.init(genError.rawValue)
    }
    
    public init(errorDescription: String) {
        super.init(errorDescription)
    }
    
    public convenience init(error: T) {
        self.init()
        self.error = error
    }
    
    public func getError() -> T? {
        return self.error
    }
}
