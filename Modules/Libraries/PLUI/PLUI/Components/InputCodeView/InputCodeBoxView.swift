//
//  PasswordBox.swift
//  UITest
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

protocol InputCodeBoxViewDelegate: AnyObject {
    func codeBoxViewShouldChangeString (_ codeBoxView: InputCodeBoxView, replacementString string: String) -> Bool
    func codeBoxViewDidBeginEditing (_ codeBoxView: InputCodeBoxView)
    func codeBoxViewDidEndEditing (_ codeBoxView: InputCodeBoxView)
    func codeBoxViewDidDelete (_ codeBoxView: InputCodeBoxView)
}

class InputCodeBoxView: UIView {

    private enum Constants {
        static let positionLabelHeight: CGFloat = 24.0
        static let positionLabelFontColor = UIColor.white
        static let positionLabelFont = UIFont.systemFont(ofSize: 14.0)
        static let defaultWitdh: CGFloat = 31.0
        static let defaultHeight: CGFloat = 56.0
    }

    private lazy var codeTextField: CodeTextField = {
        return CodeTextField(delegate: self, isSecureEntry: self.isSecureEntry)
    }()
    let position: NSInteger
    let showPosition: Bool
    let enabled: Bool
    private let isSecureEntry: Bool
    private let size: CGSize
    private let positionLabel = UILabel()
    weak var delegate: InputCodeBoxViewDelegate?

    /**
     - Parameters:
     - Parameter position: position number
     - Parameter showPosition: If true the position number is shown bellow the textField
     - Parameter delegate: delegate
     - Parameter enabled: If false then it will be not editable. It is shown a rounded square in its place
     - Parameter isSecureEntry: If true the characters entered are not shown
     - Parameter size: size of the codeTextField. The positionLabel has its own size
     */
    init(position: NSInteger,
         showPosition: Bool = false,
         delegate: InputCodeBoxViewDelegate? = nil,
         enabled: Bool,
         isSecureEntry: Bool = true,
         size: CGSize = CGSize(width: Constants.defaultWitdh, height: Constants.defaultHeight)) {
        self.showPosition = showPosition
        self.position = position
        self.enabled = enabled
        self.isSecureEntry = isSecureEntry
        self.size = size
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        self.configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult override func becomeFirstResponder() -> Bool {
        return self.codeTextField.becomeFirstResponder()
    }

    @discardableResult override func resignFirstResponder() -> Bool {
        return self.codeTextField.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        return self.codeTextField.isFirstResponder
    }

    func setKeyboardType(_ keyboardType : UIKeyboardType) {
        self.codeTextField.keyboardType = keyboardType

    }

    var text: String? {
        get {
            return self.codeTextField.text
        }
        set {
            self.codeTextField.text = newValue
        }
    }
}

private extension InputCodeBoxView {

    func configureView() {
        self.addSubviews()
        self.configureSubviews()
        self.configureConstraints()
    }

    func addSubviews() {
        self.addSubview(self.codeTextField)
        self.addSubview(self.positionLabel)
    }

    func configureSubviews() {
        self.codeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.codeTextField.isEnabled = self.enabled

        self.positionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.positionLabel.text = String(self.position)
        self.positionLabel.backgroundColor = .clear
        self.positionLabel.textAlignment = .center
        self.positionLabel.textColor = Constants.positionLabelFontColor
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.codeTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.codeTextField.topAnchor.constraint(equalTo: self.topAnchor),
            self.codeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.codeTextField.widthAnchor.constraint(equalToConstant: self.size.width),
            self.codeTextField.heightAnchor.constraint(equalToConstant: self.size.height),

            self.positionLabel.topAnchor.constraint(equalTo: self.codeTextField.bottomAnchor),
            self.positionLabel.heightAnchor.constraint(equalToConstant: self.showPosition ? Constants.positionLabelHeight : 0),
            self.positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.positionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

extension InputCodeBoxView: PasswordInputTextFieldDelegate {

    func didDeleteTextField(_ textField: CodeTextField) {

        self.delegate?.codeBoxViewDidDelete(self)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {

        self.delegate?.codeBoxViewDidBeginEditing(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {

        self.delegate?.codeBoxViewDidEndEditing(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return self.delegate?.codeBoxViewShouldChangeString(self, replacementString: string) ?? false
    }
}
