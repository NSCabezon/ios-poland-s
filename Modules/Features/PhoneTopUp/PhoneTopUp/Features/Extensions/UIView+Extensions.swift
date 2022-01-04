//
//  UIView+Extensions.swift
//  PhoneTopUp
//
//  Created by 188216 on 25/11/2021.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewConstraintToEdges(_ subview: UIView) {
        self.addSubview(subview)
        subview.constrainEdges(to: self)
    }
    
    func addSubviewsConstraintToSafeAreaEdges(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func constrainEdges(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
