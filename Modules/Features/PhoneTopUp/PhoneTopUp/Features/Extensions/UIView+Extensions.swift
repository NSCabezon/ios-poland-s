//
//  UIView+Extensions.swift
//  PhoneTopUp
//
//  Created by 188216 on 25/11/2021.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewConstraintToEdges(_ subview: UIView, padding: UIEdgeInsets = .zero) {
        self.addSubview(subview)
        subview.constrainEdges(to: self, padding: padding)
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
    
    func constrainEdges(to view: UIView, padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -padding.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding.right),
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding.bottom)
        ])
    }
}
