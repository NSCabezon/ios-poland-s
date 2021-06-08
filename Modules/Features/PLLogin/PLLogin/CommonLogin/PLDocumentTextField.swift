//
//  PLDocumentTextField.swift
//  Pods
//
//  Created by Juan Sánchez Marín on 26/5/21.
//

import UIKit
import Commons
import Models
import UI

public final class PLDocumentTextField: LegacyDesignableView {
    @IBOutlet public weak var textField: ConfigurableActionsTextField!
    @IBOutlet public weak var titleLabel: UILabel!

    public var maxLenght: Int = 20

    private weak var delegate: UITextFieldDelegate? { didSet { textField.delegate = delegate } }
    private var returnAction: (() -> Void)?

    public var introducedText: String = "" {
        didSet {
            if !introducedText.isEmpty {
                configureTextAttributes()
            }
        }
    }

    private var textfieldUsableWidth: CGFloat {
        return textField.editingRect(forBounds: self.textField.bounds).width
    }

    private var kern: CGFloat = Constants.characterSpacing

    private var textfieldAttributes: [NSAttributedString.Key: Any] {
        return [.font: Constants.textLabelFont,
                .foregroundColor: UIColor.white,
                .kern: self.kern,]
    }

    private var observer: NSObjectProtocol?

    private enum Constants {
        static let titleLabelFont = UIFont.santander(family: .text, type: .regular, size: 12)
        static let textLabelFontSize: CGFloat = 22.0
        static let textLabelFont = UIFont.santander(family: .text, type: .regular, size: Constants.textLabelFontSize)
        static let characterSpacing: CGFloat = 6.0
        static let errorMargin: CGFloat = 0.01
        static let margin: CGFloat = 2.0
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        if let observer = observer { NotificationCenter.default.removeObserver(observer) }
    }

    public func setText(_ text: String?) {
        introducedText = text ?? ""
    }

    public func introducedDocument() -> String {
        return introducedText
    }

    public func setReturnAction(_ action: @escaping (() -> Void)) {
        returnAction = action
    }

    public func reset() {
        introducedText = ""
    }

    override public func commonInit() {
        super.commonInit()
        configureTextField()
        configureLoginTypeLabel()
        configureView()
    }

    override public func layoutSubviews() {
        superview?.layoutSubviews()
        self.configureTextAttributes()
    }
}

// MARK: - Private methods

private extension PLDocumentTextField {

    @objc func becomeResponder() {
        textField.becomeFirstResponder()
    }

    func configureTextAttributes() {
        textField.attributedText = NSAttributedString(string: self.introducedText,
                                                      attributes: self.textfieldAttributes)
        let currentTextWidth = (introducedText as NSString).size(withAttributes: self.textfieldAttributes).width
        if currentTextWidth > textfieldUsableWidth {
            kern = self.calculateNewKern(for: currentTextWidth)
            configureTextAttributes()
        } else if currentTextWidth < (textfieldUsableWidth - Constants.margin) && kern < Constants.characterSpacing {
            kern = Constants.characterSpacing
            configureTextAttributes()
        }
    }

    func calculateNewKern(for currentTextWidth: CGFloat) -> CGFloat {
        let charactersNumber = CGFloat(introducedText.count)
        let characterWidthPlusKern = currentTextWidth / charactersNumber
        let characterWidth = characterWidthPlusKern - kern
        let newKern = textfieldUsableWidth / charactersNumber - characterWidth - Constants.errorMargin
        return newKern >= 0 ? newKern : 0
    }

    func configureTextField() {
        textField.textColor = UIColor.Legacy.uiWhite
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Constants.textLabelFont,
            .foregroundColor: UIColor.white,
        ]
        textField.attributedPlaceholder = NSAttributedString(string: localized("pl_login_hint_login"),
                                                             attributes: attributes)
        textField.adjustsFontSizeToFitWidth = false
        textField.returnKeyType = .next
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        if #available(iOS 11, *) {
            textField.textContentType = .username
        }
    }

    func configureLoginTypeLabel() {
        titleLabel.textColor = .white
        titleLabel.text = localized("pl_login_label_login").plainText
        titleLabel.font = Constants.titleLabelFont
    }

    func configureView() {
        contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeResponder)))
        contentView?.isUserInteractionEnabled = true
        observer = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { [weak self] (notification) in
            self?.setText((notification.object as? UITextField)?.text)
        }
    }
}
