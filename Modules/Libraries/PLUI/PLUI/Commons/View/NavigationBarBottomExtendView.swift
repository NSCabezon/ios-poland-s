//
//  NavigationBarBottomExtendView.swift
//  PLUI
//
//  Created by 186493 on 22/06/2021.
//

import Foundation
import UI

public final class NavigationBarBottomExtendView: UIView {
    
    private let bottomLineView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            var size = super.intrinsicContentSize
            size.height = max(size.height, 58)
            return size
        }
    }
    
    private func setup() {
        backgroundColor = .skyGray
        
        addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLineView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomLineView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        // TODO: Move color to the separate module
        bottomLineView.backgroundColor = UIColor(red: 218.0 / 255.0, green: 220.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    
}
