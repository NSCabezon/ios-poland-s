//
//  InputCodeBoxView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

protocol PLUIInputCodeBoxViewDelegate: AnyObject {
    func codeBoxViewShouldChangeString (_ codeBoxView: PLUIInputCodeBoxView, replacementString string: String) -> Bool
    func codeBoxViewDidBeginEditing (_ codeBoxView: PLUIInputCodeBoxView)
    func codeBoxViewDidEndEditing (_ codeBoxView: PLUIInputCodeBoxView)
    func codeBoxViewDidDelete (_ codeBoxView: PLUIInputCodeBoxView, goToPrevious: Bool)
}

public class PLUIInputCodeBoxView: UIView {

    private enum Constants {
        static let positionLabelHeight: CGFloat = 24.0
        static let positionLabelFontColor = UIColor.white
        static let positionLabelFont = UIFont.systemFont(ofSize: 14.0)

        enum AccesibilityIdentifiers {
            static let textField = "TextCodeItem"
            static let positionLabel = "LabelCodeItem"
        }
    }
    
    public enum PositionBox: Int {
        case first
        case middle
        case last
    }

    private lazy var codeTextField: PLUIInputCodeTextField = {
        return PLUIInputCodeTextField(delegate: self,
                                      font: self.font,
                                      isSecureEntry: self.isSecureEntry,
                                      cursorTintColor: self.cursorTintColor,
                                      textColor: self.textColor)
    }()
    private let elementsNumber: NSInteger
    let position: NSInteger
    let showPosition: Bool
    let requested: Bool
    private let isSecureEntry: Bool
    private let size: CGSize
    private let positionLabel = UILabel()
    private let font: UIFont
    private let textColor: UIColor
    private let cursorTintColor: UIColor
    private var roundCorners: UIRectCorner? = nil
    private var cornerRadius: CGFloat? = nil
    private let borderColor: UIColor
    private let borderWidth: CGFloat
    weak var delegate: PLUIInputCodeBoxViewDelegate?
    public var isEmpty: Bool {
        return self.text?.count ?? 0 == 0
    }

    /**
     - Parameters:
     - Parameter position: position number
     - Parameter showPosition: If true the position number is shown bellow the textField
     - Parameter delegate: delegate
     - Parameter requested: If true the user´s entry is needed. If false it will be not editable. It is shown a rounded square in its place
     - Parameter isSecureEntry: If true the characters entered are not shown
     - Parameter size: size of the codeTextField. The positionLabel has its own size
     - Parameter font: font for the textfield
     - Parameter textColor: text color in textField
     - Parameter cursorTintColor: uicolor value to tint the cursor in each textfield
     - Parameter borderColor: uicolor value for the box border.
     - Parameter borderRadius: border width
     */
    init(position: NSInteger,
         showPosition: Bool = false,
         elementsNumber: NSInteger,
         delegate: PLUIInputCodeBoxViewDelegate? = nil,
         requested: Bool,
         isSecureEntry: Bool = true,
         size: CGSize,
         font: UIFont,
         textColor: UIColor = .white,
         cursorTintColor: UIColor,
         borderColor: UIColor,
         borderWidth: CGFloat) {
        self.showPosition = showPosition
        self.elementsNumber = elementsNumber
        self.position = position
        self.requested = requested
        self.isSecureEntry = isSecureEntry
        self.size = size
        self.font = font
        self.textColor = textColor
        self.cursorTintColor = cursorTintColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        self.configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult public override func becomeFirstResponder() -> Bool {
        return self.codeTextField.becomeFirstResponder()
    }

    @discardableResult public override func resignFirstResponder() -> Bool {
        return self.codeTextField.resignFirstResponder()
    }

    public override var isFirstResponder: Bool {
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

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let corners = self.roundCorners, let radius = self.cornerRadius {
            self.roundCorners(corners: corners, radius: radius)
            self.clipsToBounds = true
        }
        if borderWidth > 0 {
            self.addBorder(width: borderWidth, color: borderColor)
        }
    }

    func configureCorners(corners: UIRectCorner, radius: CGFloat) {
        self.cornerRadius = radius
        self.roundCorners = corners
        self.clipsToBounds = true
        setNeedsDisplay()
    }
    
    public func getPosition() -> PositionBox {
        switch self.position {
        case 1: return .first
        case self.elementsNumber: return .last
        default: return .middle
        }
    }
}

private extension PLUIInputCodeBoxView {

    func configureView() {
        self.addSubviews()
        self.configureSubviews()
        self.configureConstraints()
        self.configureAccessibilityIdentifiers()
    }

    func addSubviews() {
        self.addSubview(self.codeTextField)
        self.addSubview(self.positionLabel)
    }

    func configureSubviews() {
        self.codeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.codeTextField.isEnabled = self.requested
        self.codeTextField.textColor = self.textColor

        self.positionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.positionLabel.text = String(self.position)
        self.positionLabel.backgroundColor = .clear
        self.positionLabel.textAlignment = .center
        self.positionLabel.textColor = Constants.positionLabelFontColor
    }

    func configureConstraints() {
        let widthConstraint = self.codeTextField.widthAnchor.constraint(equalToConstant: self.size.width)
        widthConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            widthConstraint,
            self.codeTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.codeTextField.topAnchor.constraint(equalTo: self.topAnchor),
            self.codeTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.codeTextField.heightAnchor.constraint(equalToConstant: self.size.height),

            self.positionLabel.topAnchor.constraint(equalTo: self.codeTextField.bottomAnchor),
            self.positionLabel.heightAnchor.constraint(equalToConstant: self.showPosition ? Constants.positionLabelHeight : 0),
            self.positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.positionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    /// Add a border considering the rounded corners, and iOS 10.3 dependency
    func addBorder(width: CGFloat, color: UIColor) {
        if let corners = self.roundCorners, let radius = self.cornerRadius {
            let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let borderLayer = CAShapeLayer()
            borderLayer.path = borderPath.cgPath
            borderLayer.lineWidth = width + 1
            borderLayer.strokeColor = color.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
        } else {
            self.layer.borderWidth = width
            self.layer.borderColor = color.cgColor
        }
    }

    func configureAccessibilityIdentifiers() {
        self.codeTextField.accessibilityIdentifier = Constants.AccesibilityIdentifiers.textField
        self.positionLabel.accessibilityIdentifier = Constants.AccesibilityIdentifiers.positionLabel
    }
}

extension PLUIInputCodeBoxView: PLUIInputCodeTextFieldDelegate {

    func didDeleteTextField(_ textField: PLUIInputCodeTextField, goToPrevious: Bool) {

        self.delegate?.codeBoxViewDidDelete(self, goToPrevious: goToPrevious)
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
