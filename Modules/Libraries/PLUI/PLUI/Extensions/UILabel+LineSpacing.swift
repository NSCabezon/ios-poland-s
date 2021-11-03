//
//  UILabel+LineSpacing.swift
//  BLIK
//
//  Created by 186491 on 23/07/2021.
//

import UIKit

public extension UILabel {
    func setInterlineSpacing(spacingValue: CGFloat = 4) {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = spacingValue
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .font,
            value: font,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: textColor,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedText = attributedString
    }

}
