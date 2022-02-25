//
//  PLLoginButton.swift
//  Account
//
//  Created by Juan Sánchez Marín on 26/5/21.
//

import Foundation
import UIKit
import UI
import CoreFoundationLib

@IBDesignable
public final class PLLoginButton: UIButton {

    public override var isEnabled: Bool {
        didSet {
            colourForState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureDraw()
    }

    func configureDraw () {
        layer.cornerRadius = frame.height / 2.0
    }

    func configure() {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        clipsToBounds = true
        titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        isEnabled = false
    }

    internal func colourForState() {
        backgroundColor = isEnabled ? UIColor.santanderRed : UIColor.lightSanGray
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureDraw()
    }
}
