//
//  PLUIInputCodeFacadeProtocol.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 3/6/21.
//

public protocol PLUIInputCodeFacadeProtocol: AnyObject {
    func view(with boxes: [PLUIInputCodeBoxView]) -> UIView
    func configuration() -> PLUIInputCodeFacadeConfiguration
}

public struct PLUIInputCodeFacadeConfiguration {
    let showPositions: Bool
    let showSecureEntry: Bool
    let elementsNumber: NSInteger
    let font: UIFont
}