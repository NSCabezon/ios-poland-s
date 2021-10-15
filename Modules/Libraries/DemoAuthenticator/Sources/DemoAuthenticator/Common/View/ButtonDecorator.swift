//
//  ButtonDecorator.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class ButtonDecorator {}

extension ButtonDecorator: ViewDecorating {
    func decorate(view: UIView) {
        guard let view = view as? UIButton else {
            return
        }
        setupPadding(in: view)
        setupBorder(in: view)
        setupColors(in: view)
        setupFont(in: view)
    }

    private func setupPadding(in view: UIButton) {
        view.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    private func setupBorder(in view: UIButton) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.cornerRadius = 4
    }

    private func setupColors(in view: UIButton) {
        view.backgroundColor = .white
        view.setTitleColor(.red, for: .highlighted)
        view.setTitleColor(.blue, for: .normal)
        view.tintColor = .blue
    }

    private func setupFont(in view: UIButton) {
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
}
