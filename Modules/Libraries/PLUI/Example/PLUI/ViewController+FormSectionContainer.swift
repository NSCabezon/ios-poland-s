//
//  ViewController+FormSectionContainer.swift
//  PLUI_Example
//
//  Created by 185167 on 04/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import PLUI

extension ViewController {
    func formSectionContainer() -> UIView {
        let label = UILabel()
        label.text = "Example subview"
        label.textAlignment = .center
        label.backgroundColor = .magenta
        let sectionContainer = FormSectionContainer(
            containedView: label,
            sectionTitle: "Section Title"
        )
        sectionContainer.backgroundColor = .white
        
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return sectionContainer
    }
}
