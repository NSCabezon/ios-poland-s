//
//  PasswordBox.swift
//  UITest
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

protocol PasswordInputBoxViewDelegate: AnyObject {
    func passwordInputBoxViewShouldChangeString (_ paswwordInputBoxView: PasswordInputBoxView, replacementString string: String) -> Bool
    func passwordInputBoxViewDidBeginEditing (_ paswwordInputBoxView: PasswordInputBoxView)
    func passwordInputBoxViewDidEndEditing (_ paswwordInputBoxView: PasswordInputBoxView)
    func passwordInputBoxViewDidDelete (_ paswwordInputBoxView: PasswordInputBoxView)
}

class PasswordInputBoxView: UIView {

    private enum Constants {
        static let positionLabelHeight: CGFloat = 24.0
        static let positionLabelFontColor = UIColor.white
        static let positionLabelFont = UIFont.systemFont(ofSize: 14.0)
    }

    private lazy var passwordInputTextField: PasswordInputTextField = {
        return PasswordInputTextField(delegate: self, isSecureEntry: self.isSecureEntry)
    }()
    let position: NSInteger
    let showPosition: Bool
    let enabled: Bool
    private let isSecureEntry: Bool
    private let positionLabel = UILabel()
    weak var delegate: PasswordInputBoxViewDelegate?

    init(position: NSInteger,
         showPosition: Bool = false,
         delegate: PasswordInputBoxViewDelegate? = nil,
         enabled: Bool,
         isSecureEntry: Bool = true) {
        self.showPosition = showPosition
        self.position = position
        self.enabled = enabled
        self.isSecureEntry = isSecureEntry
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        self.configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult override func becomeFirstResponder() -> Bool {
        return self.passwordInputTextField.becomeFirstResponder()
    }

    @discardableResult override func resignFirstResponder() -> Bool {
        return self.passwordInputTextField.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        return self.passwordInputTextField.isFirstResponder
    }

    func setKeyboardType(_ keyboardType : UIKeyboardType) {
        self.passwordInputTextField.keyboardType = keyboardType

    }

    var text: String? {
        get {
            return self.passwordInputTextField.text
        }
        set {
            self.passwordInputTextField.text = newValue
        }
    }
}

private extension PasswordInputBoxView {

    func configureView() {
        self.addSubviews()
        self.configureSubviews()
        self.configureConstraints()
    }

    func addSubviews() {
        self.addSubview(self.passwordInputTextField)
        self.addSubview(self.positionLabel)
    }

    func configureSubviews() {
        self.passwordInputTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordInputTextField.isEnabled = self.enabled

        self.positionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.positionLabel.text = String(self.position)
        self.positionLabel.backgroundColor = .clear
        self.positionLabel.textAlignment = .center
        self.positionLabel.textColor = Constants.positionLabelFontColor
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.passwordInputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.passwordInputTextField.topAnchor.constraint(equalTo: self.topAnchor),
            self.passwordInputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.positionLabel.topAnchor.constraint(equalTo: self.passwordInputTextField.bottomAnchor),
            self.positionLabel.heightAnchor.constraint(equalToConstant: self.showPosition ? Constants.positionLabelHeight : 0),
            self.positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.positionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension PasswordInputBoxView: PasswordInputTextFieldDelegate {

    func didDeleteTextField(_ textField: PasswordInputTextField) {

        self.delegate?.passwordInputBoxViewDidDelete(self)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {

        self.delegate?.passwordInputBoxViewDidBeginEditing(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {

        self.delegate?.passwordInputBoxViewDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return self.delegate?.passwordInputBoxViewShouldChangeString(self, replacementString: string) ?? false
    }
}
