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

public class PLDocumentTextField: LegacyDesignableView {
    @IBOutlet public weak var textField: ConfigurableActionsTextField!
    @IBOutlet public weak var titleLabel: UILabel!

    public var keyboardType: UIKeyboardType = .default

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

    public var hiddenText: String = "" {
        didSet {
            if hiddenText.count > maxLength {
                hiddenText = ""
                textField?.text = ""
            }
            updatePassword()
        }
    }
    public var state: State = .secure {
        didSet {
            updatePassword()
        }
    }

    public let maxLength: Int = 20

    public enum State {
        case char
        case secure
    }

    private enum Constants {
        static let titleLabelFont = UIFont.santander(family: .text, type: .regular, size: 12)
        static let textLabelFontSize: CGFloat = 22.0
        static let textLabelFont = UIFont.santander(family: .text, type: .regular, size: Constants.textLabelFontSize)
        static let characterSpacing: CGFloat = 6.0
        static let errorMargin: CGFloat = 0.01
        static let margin: CGFloat = 2.0
        static let cursorColor = UIColor.santanderRed
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
        configureLoginTypeLabel(text: localized("pl_login_label_login"))
        configureView()
    }

    override public func layoutSubviews() {
        superview?.layoutSubviews()
    }
}

// MARK: - Private methods

extension PLDocumentTextField {

    @objc func becomeResponder() {
        textField.becomeFirstResponder()
    }

    func configureTextAttributes() {
        textField.text = introducedText
        let currentTextWidth = (introducedText as NSString).size(withAttributes: self.textfieldAttributes).width
        if currentTextWidth > textfieldUsableWidth {
            kern = self.calculateNewKern(for: currentTextWidth)
            self.resetDefaultAttributedTextKern()
            configureTextAttributes()
        } else if currentTextWidth < (textfieldUsableWidth - Constants.margin) && kern < Constants.characterSpacing {
            kern = Constants.characterSpacing
            self.resetDefaultAttributedTextKern()
            configureTextAttributes()
        }
    }

    func resetDefaultAttributedTextKern() {
        textField.defaultTextAttributes.updateValue(self.kern, forKey: .kern)
    }

    func calculateNewKern(for currentTextWidth: CGFloat) -> CGFloat {
        let charactersNumber = CGFloat(introducedText.count)
        let characterWidthPlusKern = currentTextWidth / charactersNumber
        let characterWidth = characterWidthPlusKern - kern
        let newKern = textfieldUsableWidth / charactersNumber - characterWidth - Constants.errorMargin
        return newKern >= 0 ? newKern : 0
    }

    public func configureTextField() {
        textField.textColor = UIColor.Legacy.uiWhite
        textField.tintColor = Constants.cursorColor
        textField.adjustsFontSizeToFitWidth = false
        textField.returnKeyType = .next
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        if #available(iOS 11, *) {
            textField.textContentType = .username
        }
        textField.defaultTextAttributes = self.textfieldAttributes
        configureTextFieldPlaceholder(text: localized("pl_login_hint_login"))
        self.resetDefaultAttributedTextKern()
    }

    public func configureTextFieldPlaceholder(text: LocalizedStylableText? = nil) {
        guard let text = text else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Constants.textLabelFont,
            .foregroundColor: UIColor.white,
        ]
        textField.attributedPlaceholder = NSAttributedString(string: text.text,
                                                             attributes: attributes)
    }

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

    public func configureLoginTypeLabel(text: LocalizedStylableText) {
        titleLabel.textColor = .white
        titleLabel.text = text.text
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
