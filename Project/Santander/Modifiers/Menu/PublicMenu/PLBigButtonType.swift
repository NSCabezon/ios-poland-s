//
//  PLBigButtonType.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 25/1/22.
//
import CoreFoundationLib

struct PLBigButtonType: BigButtonTypeRepresentable {
    public var font: UIFont
    public var lineBreakMode: NSLineBreakMode
    public var numberOfLines: Int
    public var minimumScaleFactor: CGFloat?
    
    init(fontSize: CGFloat) {
        self.font = UIFont.santander(size: fontSize)
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 2
        self.minimumScaleFactor = nil
    }
}
