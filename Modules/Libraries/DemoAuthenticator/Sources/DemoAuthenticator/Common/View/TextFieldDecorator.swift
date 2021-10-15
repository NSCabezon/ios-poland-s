//
//  TextFieldDecorator.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class TextFieldDecorator {}

extension TextFieldDecorator: ViewDecorating {
    func decorate(view: UIView) {
        guard let view = view as? UITextField else {
            return
        }
        setupPadding(in: view)
        setupBorder(in: view)
        setupColors(in: view)
        setupFont(in: view)
        setupLayout(in: view)
    }

    private func setupPadding(in view: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
    }

    private func setupBorder(in view: UITextField) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 4
    }

    private func setupColors(in view: UITextField) {
        view.backgroundColor = .white
        view.textColor = .black
        view.tintColor = .black
    }

    private func setupFont(in view: UITextField) {
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    private func setupLayout(in view: UITextField) {
        view.textAlignment = .left
        view.contentVerticalAlignment = .center
    }
}
