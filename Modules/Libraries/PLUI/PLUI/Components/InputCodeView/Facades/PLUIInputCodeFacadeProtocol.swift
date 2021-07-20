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
    let cursorTintColor: UIColor
    let textColor: UIColor
    let borderColor: UIColor
    let borderWidth: CGFloat

    init(showPositions: Bool, showSecureEntry: Bool, elementsNumber: NSInteger, font: UIFont,
         cursorTintColor: UIColor = .santanderRed, textColor: UIColor = .white,
         borderColor:UIColor = .clear, borderWidth: CGFloat = 0) {
        self.showPositions = showPositions
        self.showSecureEntry = showSecureEntry
        self.elementsNumber = elementsNumber
        self.font = font
        self.cursorTintColor = cursorTintColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
}
