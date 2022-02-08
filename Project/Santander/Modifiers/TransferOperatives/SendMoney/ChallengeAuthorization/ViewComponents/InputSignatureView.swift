//
//  InputSignatureView.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 26/10/21.
//

import UI
import PLUI
import CoreFoundationLib
import PLCommons
import Foundation
import UIOneComponents

public protocol InputSignatureViewDelegate: AnyObject {
    func didPinChange(pin: String, isPinComplete: Bool)
}

public final class InputSignatureView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pinContainerView: UIView!
    private var view: UIView?
    public weak var delegate: InputSignatureViewDelegate?
    private var pinInputComplete: Bool = false
    private enum Constants {
        static let pinBoxSize = CGSize(width: 47.0, height: 48.0)
        static let pinCharacterSet: CharacterSet = .decimalDigits
    }
    private var facade = PLUIInputCodePinFacade()
    private lazy var pinInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                             delegate: self,
                                                                             facade: self.facade,
                                                                             elementSize: Constants.pinBoxSize,
                                                                             requestedPositions: .all,
                                                                             charactersSet: Constants.pinCharacterSet)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
        self.configureLabel()
        self.configurePinView()
        self.setAccessibilityIdentifiers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetup()
        self.configureLabel()
        self.configurePinView()
        self.setAccessibilityIdentifiers()
    }
}

private extension InputSignatureView {
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view ?? UIView())
        self.view?.fullFit()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
    
    func configureLabel() {
        self.titleLabel.font = .typography(fontName: .oneH100Regular)
        self.titleLabel.textColor = .oneLisboaGray
        self.titleLabel.configureText(withKey: "authorization_label_enterYourPin")
    }
    
    func configurePinView() {
        self.facade.setConstants(elementWidth: 47.0, elementHeight: 48.0, spacingBetweenColumns: 0.0, font: UIFont.systemFont(ofSize: 17), cursorTintColor: UIColor.Legacy.uiBlack)
        self.pinContainerView.addSubview(self.pinInputCodeView)
        NSLayoutConstraint.activate([
            self.pinInputCodeView.leadingAnchor.constraint(equalTo: self.pinContainerView.leadingAnchor),
            self.pinInputCodeView.trailingAnchor.constraint(equalTo: self.pinContainerView.trailingAnchor),
            self.pinInputCodeView.topAnchor.constraint(equalTo: self.pinContainerView.topAnchor),
            self.pinInputCodeView.bottomAnchor.constraint(equalTo: self.pinContainerView.bottomAnchor)
        ])
    }
    
    func setAccessibilityIdentifiers() {
        self.titleLabel.accessibilityIdentifier = AccessibilityAuthorization.signatureTitleLabel
        self.pinInputCodeView.accessibilityIdentifier = AccessibilityAuthorization.pinInputView
    }
}

extension  InputSignatureView: PLUIInputCodeViewDelegate {

    public func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        self.delegate?.didPinChange(pin: view.getPin(), isPinComplete: view.isFulfilled())
    }

    public func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {
        if string.count == 0 { return true }
        guard string.count > 0,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(character) else {
            return false
        }
        return true
    }

    public func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {
        view.setBoxView(position: position, backgroundColor: .oneTurquoise.withAlphaComponent(0.07), borderWidth: 2, borderColor: .oneDarkTurquoise)
    }

    public func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) {
        view.setBoxView(position: position, backgroundColor: .clear, borderWidth: 1, borderColor: .oneBrownGray)
    }
}
