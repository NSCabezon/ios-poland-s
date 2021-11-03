//
//  PinTextField.swift
//  Santander
//
//  Created by 186491 on 28/05/2021.
//

import UIKit
import PLCommons

public protocol PinInputViewDelegte: AnyObject {
    func didUpdateField()
    func pinInputViewDidFinishEdit(_ view: PinInputView)
}

public final class PinInputView: UIView {
    private lazy var contentStackView: UIStackView = makeContentStackView()
    private let pinNumberLength: Int
    
    public var pin: String {
        get {
            contentStackView.arrangedSubviews.reduce("", { result, view in
                guard let inputView = view as? PinTextField else {
                    return result
                }
                
                return result.appending(inputView.actualText ?? "")
            })
        }
    }
    
    public var isInputFullyFilled: Bool {
        return pin.count == pinNumberLength
    }
    
    public weak var delegate: PinInputViewDelegte?
    
    public init(pinNumberLength: Int, accessibilityIdentifier: String) {
        self.pinNumberLength = pinNumberLength
        super.init(frame: .zero)
        contentStackView.accessibilityIdentifier = accessibilityIdentifier
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func becomeFirstResponder() -> Bool {
        findFirstResponder()?.becomeFirstResponder()
        return false
    }
}

private extension PinInputView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        for id in 0..<pinNumberLength {
            let inputField = PinTextField()
            inputField.accessibilityIdentifier = AccessibilityCheques.PinInputView.inputItem.id + ".\(id)"
            inputField.delegate = self
            inputField.deleteBackwardDelegate = self
            contentStackView.addArrangedSubview(inputField)
        }
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureStyling() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.mediumSkyGray.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .mediumSkyGray
    }
    
    func findFirstResponder() -> PinTextField? {
        contentStackView.arrangedSubviews.first { view in
            guard let inputView = view as? PinTextField else {
                return false
            }
            
            return inputView.text?.isEmpty ?? true
        } as? PinTextField
    }
    
    func findPrevResponder(after currentTextField: PinTextField) -> PinTextField? {
        if currentTextField == contentStackView.arrangedSubviews.first {
            return nil
        } else if let index = contentStackView.arrangedSubviews.lastIndex(of: currentTextField) {
            return contentStackView.arrangedSubviews[index - 1] as? PinTextField
        } else {
            return nil
        }
    }
    
    func clearInput() {
        contentStackView.arrangedSubviews.forEach {
            guard let textField = $0 as? PinTextField else {
                return
            }
            
            textField.text = ""
            textField.actualText = ""
            delegate?.didUpdateField()
        }
    }
    
    func makeContentStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension PinInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = "●"
        (textField as? PinTextField)?.actualText = string
        
        if let nextResponder = findFirstResponder() {
            nextResponder.becomeFirstResponder()
        } else {
            endEditing(true)
            delegate?.pinInputViewDidFinishEdit(self)
        }
        delegate?.didUpdateField()
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let responder = findFirstResponder() else {
            clearInput()
            let responder = findFirstResponder()
            responder?.becomeFirstResponder()
            return false
        }
        
        if responder == textField {
            return true
        }

        responder.becomeFirstResponder()
        return false
    }
}

extension PinInputView: PinTextFieldDelegate {
    func textFieldDidDeleteBackward(_ textField: PinTextField) {
        let prevResponder = findPrevResponder(after: textField)
        if prevResponder != nil {
            prevResponder?.text = ""
            prevResponder?.actualText = ""
            prevResponder?.becomeFirstResponder()
        }
    }
}
