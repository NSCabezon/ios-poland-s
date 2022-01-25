//
//  PLGenericErrorPresenterLayerProtocol.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import Foundation

public protocol PLGenericErrorPresenterLayerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? { get }
    func handle(error: PLGenericError, showTitle: Bool, showCloseButton: Bool)
    func genericErrorPresentedWith(error: PLGenericError)
    func otherErrorPresentedWith<T>(error: T)
}

extension PLGenericErrorPresenterLayerProtocol {
    public func handle(error: PLGenericError, showTitle: Bool = true, showCloseButton: Bool = false) {
        let errorConfig = PLGenericErrorConfig(showTitle: showTitle, showCloseButton: showCloseButton)
        associatedErrorView?.presentError(error, errorConfig, completion: {
            genericErrorPresentedWith(error: error)
        })
    }
    
    public func otherErrorPresentedWith<T>(error: T) {
        genericErrorPresentedWith(error: .other("\(error)"))
    }
}
