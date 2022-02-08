//
//  ChequePinView.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import UIKit
import UI
import PLUI
import CoreFoundationLib
import PLCommons

class ChequePinView: UIView {
    public var saveButtonOnTap: (() -> Void)?
    
    private(set) lazy var scrollView = makeScrollView()
    private(set) lazy var hintLabel = makeHintLabel()
    private(set) lazy var lockImageView = makeLockImageView()
    private(set) lazy var titleLabel = makeTitleLabel()
    private(set) lazy var pinLabel = makePinLabel()
    private(set) lazy var pinInput = makePinInput(
        accessibilityIdentifier: AccessibilityCheques.ChequePinView.pinInput.id
    )
    private(set) lazy var pinConfirmationLabel = makePinConfirmationLabel()
    private(set) lazy var pinConfirmationInput = makePinInput(
        accessibilityIdentifier: AccessibilityCheques.ChequePinView.pinConfirmationInput.id
    )
    private(set) lazy var footerView = makeFooterView()
    
    init() {
        super.init(frame: .zero)
        buildUI()
        setIdentifiers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChequePinView {
    func buildUI() {
        backgroundColor = .white
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(lockImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(pinLabel)
        scrollView.addSubview(pinInput)
        scrollView.addSubview(pinConfirmationLabel)
        scrollView.addSubview(pinConfirmationInput)
        addSubview(footerView)
        addSubview(scrollView)
        
        buildConstraints()
    }
    
    func buildConstraints() {
        var viewLayoutGuide = layoutMarginsGuide
        if #available(iOS 11.0, *) {
            viewLayoutGuide = safeAreaLayoutGuide
        }
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: viewLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            hintLabel.leadingAnchor.constraint(equalTo: viewLayoutGuide.leadingAnchor, constant: 16),
            hintLabel.trailingAnchor.constraint(equalTo: viewLayoutGuide.trailingAnchor, constant: -16),

            lockImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 32),
            lockImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: hintLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: hintLabel.trailingAnchor),

            pinLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            pinLabel.leadingAnchor.constraint(equalTo: hintLabel.leadingAnchor),
            pinLabel.trailingAnchor.constraint(equalTo: hintLabel.trailingAnchor),

            pinInput.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 16),
            pinInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pinInput.widthAnchor.constraint(equalToConstant: 180),
            pinInput.heightAnchor.constraint(equalToConstant: 48),

            pinConfirmationLabel.topAnchor.constraint(equalTo: pinInput.bottomAnchor, constant: 32),
            pinConfirmationLabel.leadingAnchor.constraint(equalTo: hintLabel.leadingAnchor),
            pinConfirmationLabel.trailingAnchor.constraint(equalTo: hintLabel.trailingAnchor),

            pinConfirmationInput.topAnchor.constraint(equalTo: pinConfirmationLabel.bottomAnchor, constant: 16),
            pinConfirmationInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pinConfirmationInput.widthAnchor.constraint(equalToConstant: 180),
            pinConfirmationInput.heightAnchor.constraint(equalToConstant: 48),
            pinConfirmationInput.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }
    
    func makeHintLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(
            string: localized("pl_blik_text_passUseInform"),
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.santander(family: .text, type: .regular, size: 12),
                .foregroundColor: UIColor.darkGray
            ]
        )
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeLockImageView() -> UIImageView {
        let imageView = UIImageView(image: Assets.image(named: "icnLock"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = localized("pl_blik_title_chequePass")
        label.setSantanderTextFont(type: .bold, size: 17, color: .darkGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makePinLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = localized("pl_blik_text_numbPass")
        label.setSantanderTextFont(type: .regular, size: 17, color: .darkGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makePinInput(accessibilityIdentifier: String) -> PinInputView {
        let textField = PinInputView(pinNumberLength: 4, accessibilityIdentifier: accessibilityIdentifier)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makePinConfirmationLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = localized("pl_blik_text_repeatPass")
        label.setSantanderTextFont(type: .regular, size: 17, color: .darkGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeFooterView() -> BottomButtonView {
        let view = BottomButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(title: localized("generic_button_save")) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.saveButtonOnTap?()
        }
        return view
    }
    
    func setIdentifiers() {
        hintLabel.accessibilityIdentifier = AccessibilityCheques.ChequePinView.hintLabel.id
        lockImageView.accessibilityIdentifier = AccessibilityCheques.ChequePinView.lockImageView.id
        titleLabel.accessibilityIdentifier = AccessibilityCheques.ChequePinView.titleLabel.id
        pinLabel.accessibilityIdentifier = AccessibilityCheques.ChequePinView.pinLabel.id
        pinConfirmationLabel.accessibilityIdentifier = AccessibilityCheques.ChequePinView.pinConfirmationLabel.id
        footerView.accessibilityIdentifier = AccessibilityCheques.ChequePinView.footerView.id
    }
}
