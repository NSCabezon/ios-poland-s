//
//  BottomDualButtonView.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 26/07/2021.
//

import Foundation
import UIKit
import UI
import PLUI

struct BottomButtonViewModel {
    let title: String
    let action: () -> Void
}

final class BottomDualButtonView: UIView {
    private let separator = UIView()
    private let firstButton: LisboaButton
    private let secondButton: LisboaButton
    private var firstButtonAction: (() -> Void)?
    private var secondButtonAction: (() -> Void)?
    private let animationSpeed: TimeInterval = 0.2
    
    init(
        firstButtonStyle: BottomButtonStyle = .red,
        secondButtonStyle: BottomButtonStyle = .red
    ) {
        firstButton = firstButtonStyle == .red ? RedLisboaButton() : WhiteLisboaButton()
        secondButton = secondButtonStyle == .red ? RedLisboaButton() : WhiteLisboaButton()
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        firstButtonViewModel: BottomButtonViewModel,
        secondButtonViewModel: BottomButtonViewModel
    ) {
        firstButton.setTitle(firstButtonViewModel.title, for: .normal)
        firstButtonAction = firstButtonViewModel.action
        secondButton.setTitle(secondButtonViewModel.title, for: .normal)
        secondButtonAction = secondButtonViewModel.action
    }
    
    func enableButtons() {
        UIView.animate(withDuration: animationSpeed) {
            self.firstButton.isEnabled = true
            self.firstButton.alpha = 1.0
            self.secondButton.isEnabled = true
            self.secondButton.alpha = 1.0
        }
        
    }
    
    func disableButtons() {
        UIView.animate(withDuration: animationSpeed) {
            self.firstButton.isEnabled = false
            self.firstButton.alpha = 0.3
            self.secondButton.isEnabled = false
            self.secondButton.alpha = 0.3
        }
    }
    
    private func setUp() {
        configureTargets()
        configureSubviews()
        configureStyling()
    }
    
    private func configureTargets() {
        firstButton.addAction { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.firstButtonAction?()
        }
        secondButton.addAction { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.secondButtonAction?()
        }
    }
    
    private func configureSubviews() {
        addSubview(separator)
        addSubview(firstButton)
        addSubview(secondButton)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            firstButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            firstButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            firstButton.heightAnchor.constraint(equalToConstant: 48),
            
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 16),
            secondButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            secondButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            secondButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            secondButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureStyling() {
        separator.backgroundColor = .lightSanGray
    }
}
