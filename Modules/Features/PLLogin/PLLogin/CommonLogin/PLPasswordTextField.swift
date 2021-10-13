//
//  PLPasswordTextField.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 1/6/21.
//

import UIKit
import IQKeyboardManagerSwift
import Commons
import UI

public protocol PLPasswordTextFieldDelegate: AnyObject {
    func enterDidPressed()
}

public final class PLPasswordTextField: LegacyDesignableView, UITextFieldDelegate, UIGestureRecognizerDelegate {

    private enum State {
        case char
        case secure
    }

    private enum Constants {
        static let cursorColor = UIColor.santanderRed
    }

    @IBOutlet public weak var textField: UITextField?

    public weak var delegate: PLPasswordTextFieldDelegate?

    public var hiddenText: String = "" {
        didSet {
            if hiddenText.count > maxLength {
                hiddenText = ""
                textField?.text = ""
            }
            updatePassword()
        }
    }
    private var state: State = .secure {
        didSet {
            updatePassword()
        }
    }

    public let maxLength: Int = 20

    public func introducedPassword() -> String { return hiddenText }

    public func setPlaceholder(_ placeholder: String) {
        textField?.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                              attributes: [.foregroundColor: UIColor.Legacy.uiWhite])
    }

    public func setText(_ text: String?) { hiddenText = text ?? ""; state = .secure }

    public func reset() { hiddenText = "" }

    // MARK: - privateMethods
    override public func commonInit() {
        super.commonInit()
        configureTextField()
        contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeResponder)))
        contentView?.isUserInteractionEnabled = true
    }

    private func configureTextField() {
        textField?.textColor = UIColor.Legacy.uiWhite
        textField?.font = UIFont.santander(family: .text, type: .regular, size: Screen.isIphone4or5 ? 16.0 : 20.0)
        textField?.tintColor = Constants.cursorColor
        textField?.textAlignment = .left
        textField?.returnKeyType = .default
        textField?.delegate = self
        textField?.keyboardType = .default
        if #available(iOS 11, *) {
            textField?.textContentType = .password
        }
        textField?.autocapitalizationType = .none
        textField?.autocorrectionType = .no
        textField?.spellCheckingType = .no
        textField?.adjustsFontSizeToFitWidth = true
    }

    @objc public func becomeResponder() { textField?.becomeFirstResponder() }

    public func updatePassword() {
        let array = Array(hiddenText)
        textField?.text = array.reduce("", { return $0 + (state == .secure ? "•" : String($1)) })
        let correction: CGFloat = Screen.isIphone4or5 ? 4.0 : 0.0
        textField?.font = UIFont.santander(family: .text, type: .regular, size: (array.isEmpty ? 20 - correction : (state == .secure ? 40.0 - correction : 28.0 - correction)))

        guard let font = textField?.font else { return }
        let charSpace = (state == .secure ? "•" : "9").size(withAttributes: [NSAttributedString.Key.font: font]).width
        let total = charSpace * CGFloat(maxLength + 1) + 10
        if (textField?.frame.width ?? 0.0) - total > 0.0 {
            textField?.defaultTextAttributes.updateValue((array.isEmpty ? 0.2 : ((textField?.frame.width ?? 0.0) - total) / CGFloat(maxLength - 1)),
                                                         forKey: NSAttributedString.Key.kern)
        }
    }
    @objc func doneDidPressed() {
        delegate?.enterDidPressed()
    }

    // MARK: - UITextFieldDelegate methods
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = localized("publicHome_button_enter")
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneDidPressed))
        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = nil
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != " " else { return false }
        let currentText = hiddenText
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        guard updatedText.count <= maxLength else { return false }
        hiddenText = updatedText
        updatePassword()

        return false
    }
}
