//
//  OutlinedButton.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import UI

class OutlinedButton: UIButton {
    var accentColor: UIColor = .black {
        didSet {
            setTitleColor(accentColor, for: .normal)
            layer.borderColor = accentColor.cgColor
            imageView?.tintColor = accentColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0 : 0.3) {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OutlinedButton {
    func setup() {
        titleLabel?.font = .santander(family: .text, type: .bold, size: 14)
        layer.borderWidth = 1
        
        contentEdgeInsets = .init(top: 6, left: 24, bottom: 6, right: 35)
        imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -21)
        swapImageSide()
    }
    
    func swapImageSide() {
        let direction = UIApplication.shared.userInterfaceLayoutDirection
        semanticContentAttribute = direction == .rightToLeft
            ? .forceLeftToRight
            : .forceRightToLeft
    }
}
