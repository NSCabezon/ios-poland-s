//
//  PinTextField.swift
//  Santander
//
//  Created by 186491 on 28/05/2021.
//

import UIKit
import UI

protocol PinTextFieldDelegate: AnyObject {
    func textFieldDidDeleteBackward(_ textField: PinTextField)
}

final class PinTextField: UITextField {
    public weak var deleteBackwardDelegate: PinTextFieldDelegate?
    public var actualText: String?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        textAlignment = .center
        textColor = .darkTorquoise
        font = .santander(size: 23)
        keyboardType = .numberPad
        returnKeyType = .next
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
    
    override func deleteBackward() {
        if (text ?? "").isEmpty {
            deleteBackwardDelegate?.textFieldDidDeleteBackward(self)
        } else {
            actualText = ""
            text = ""
        }
    }
}
