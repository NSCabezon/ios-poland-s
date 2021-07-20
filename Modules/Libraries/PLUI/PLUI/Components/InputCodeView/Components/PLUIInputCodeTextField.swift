//
//  PLUIInputCodeTextField.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 20/5/21.
//

import UIKit
import UI

protocol PLUIInputCodeTextFieldDelegate: UITextFieldDelegate {
    func didDeleteTextField(_ textField: PLUIInputCodeTextField)
}

class PLUIInputCodeTextField: UITextField {

    private enum Constants {
        static let enabledBackgroundColor = UIColor(white: 1.0, alpha: 0.35)
        enum Cursor {
            static let width: CGFloat = 1.0
        }
    }

    private let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let isSecureEntry: Bool
    private let cursorTintColor: UIColor
    private let selectedFont: UIFont
    override var isEnabled: Bool {
        didSet {
            self.disabledIndicatorView.isHidden = isEnabled
            self.backgroundColor = isEnabled ? Constants.enabledBackgroundColor : UIColor.clear
        }
    }

    weak var inputCodeDelegate: PLUIInputCodeTextFieldDelegate?

    private lazy var disabledIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        view.backgroundColor = UIColor(white: 0.84, alpha: 1.0)
        view.heightAnchor.constraint(equalToConstant: 9).isActive = true
        view.widthAnchor.constraint(equalToConstant: 9).isActive = true
        self.addSubview(view)
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return view
    }()

    /**
     - Parameters:
     - Parameter delegate: delegate
     - Parameter isSecureEntry: If true the characters entered are not shown
     */
    init(delegate: PLUIInputCodeTextFieldDelegate?,
         font: UIFont,
         isSecureEntry: Bool = true,
         cursorTintColor: UIColor,
         textColor: UIColor) {
        self.inputCodeDelegate = delegate
        self.isSecureEntry = isSecureEntry
        self.cursorTintColor = cursorTintColor
        self.selectedFont = font
        super.init(frame: .zero)
        self.textColor = textColor
        self.delegate = delegate
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func deleteBackward() {
        super.deleteBackward()
        self.inputCodeDelegate?.didDeleteTextField(self)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.height = self.selectedFont.lineHeight
        rect.size.width = Constants.Cursor.width
        rect.origin.y = (self.frame.height - rect.size.height) / 2
        return rect
    }
}

private extension PLUIInputCodeTextField {

    func configureView() {
        self.borderStyle = .none
        self.isSecureTextEntry = self.isSecureEntry
        self.textAlignment = .center
        self.font = self.selectedFont
        self.tintColor = self.cursorTintColor
    }
}

