//
//  PLGenericErrorPresenterLayerProtocol.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import Foundation

public protocol PLGenericErrorPresenterLayerProtocol {
    var associatedErrorView: PLGenericErrorPresentableCapable? { get }
    func handle(error: PLGenericError)
    func genericErrorPresentedWith(error: PLGenericError)
    func otherErrorPresentedWith<T>(error: T)
}

extension PLGenericErrorPresenterLayerProtocol {
    public func handle(error: PLGenericError) {
        associatedErrorView?.presentError(error, completion: {
            genericErrorPresentedWith(error: error)
        })
    }
    public func otherErrorPresentedWith<T>(error: T) {
        genericErrorPresentedWith(error: .other("\(error)"))
    }
}
