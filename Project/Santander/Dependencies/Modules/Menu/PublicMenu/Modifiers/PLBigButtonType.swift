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
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 2
        self.minimumScaleFactor = nil
    }
}
