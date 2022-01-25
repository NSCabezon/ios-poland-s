//
//  ViewController+TappableControl.swift
//  PLUI_Example
//
//  Created by 185167 on 04/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import PLUI

extension ViewController {
    func tappableControl() -> UIView {
        let tappableControl = TappableControl()
        tappableControl.backgroundColor = .white
        let label = UILabel()
        label.text = "Example subview"
        label.textAlignment = .center
        
        tappableControl.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        tappableControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: tappableControl.topAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: tappableControl.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: tappableControl.trailingAnchor, constant: -32),
            label.bottomAnchor.constraint(equalTo: tappableControl.bottomAnchor, constant: -32),
            
            tappableControl.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return tappableControl
    }
}
