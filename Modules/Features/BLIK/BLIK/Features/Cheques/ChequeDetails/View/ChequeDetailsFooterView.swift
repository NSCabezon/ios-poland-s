//
//  ChequeDetailsFooterView.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import UIKit
import UI
import Commons
import PLCommons
import PLUI

final class ChequeDetailsFooterView: UIView {
    var sendButtonTap: (() -> Void)?
    var removeButtonTap: (() -> Void)?
    
    private(set) lazy var sendButton = makeSendButton()
    private(set) lazy var removeButton = makeRemoveButton()
    private(set) lazy var separatorView = makeSeparator()
    
    init() {
        super.init(frame: .zero)
        buildUI()
        setIdentifiers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChequeDetailsFooterView {
    func buildUI() {
        addSubview(separatorView)
        addSubview(sendButton)
        addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            sendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 48),
            
            removeButton.leadingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            removeButton.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 16),
            removeButton.trailingAnchor.constraint(equalTo: sendButton.trailingAnchor),
            removeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            removeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func makeSeparator() -> UIView {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .mediumSkyGray
        return button
    }
    
    func makeSendButton() -> LisboaButton {
        let button = RedLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localized("pl_blik_button_sendCheque"), for: .normal)
        button.addAction { [weak self] in
            self?.sendButtonTap?()
        }
        return button
    }

    func makeRemoveButton() -> LisboaButton {
        let button = WhiteLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localized("pl_blik_button_deleteCheque"), for: .normal)
        button.addAction { [weak self] in
            self?.removeButtonTap?()
        }
        return button
    }
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsFooterView.root.id
        sendButton.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsFooterView.sendButton.id
        removeButton.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsFooterView.removeButton.id
    }
}
