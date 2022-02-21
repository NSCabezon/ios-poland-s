//
//  PLBigButtonType.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 25/1/22.
//
import CoreFoundationLib

struct PLBigButtonType: BigButtonTypeRepresentable {
    var font: UIFont
    var lineBreakMode: NSLineBreakMode
    var numberOfLines: Int
    var minimumScaleFactor: CGFloat?
    
    init(fontSize: CGFloat) {
        self.font = UIFont.santander(size: fontSize)
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 2
        self.minimumScaleFactor = nil
    }
}
