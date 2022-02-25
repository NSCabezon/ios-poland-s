//
//  BlikLabelSettingsContentView.swift
//  BLIK
//
//  Created by 185167 on 23/02/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol BlikLabelSettingsContentViewDelegate: AnyObject {
    func didUpdateBlikLabel()
}

final class BlikLabelSettingsContentView: UIView {
    private let title = UILabel()
    private let blikLabelTextField = LisboaTextFieldWithErrorView()
    private let infoButton = UIButton()
    private weak var delegate: BlikLabelSettingsContentViewDelegate?
    
    public var blikCustomerLabel: String {
        blikLabelTextField.textField.text ?? ""
    }
    
    public init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with blikLabel: String) {
        blikLabelTextField.textField.setText(blikLabel)
    }
    
    func setLabelError(_ errorText: String?) {
        if let error = errorText {
            blikLabelTextField.showError(error)
        } else {
            blikLabelTextField.hideError()
        }
    }
    
    func setDelegate(_ delegate: BlikLabelSettingsContentViewDelegate?) {
        self.delegate = delegate
    }
}

private extension BlikLabelSettingsContentView {
    func setUp() {
        configureSubviews()
        configureStyling()
        configureContent()
        configureTargets()
        configureDelegates()
    }
    
    func configureContent() {
        title.text = localized("pl_blik_label_clientLabel")
        blikLabelTextField.textField.setPlaceholder(localized("pl_blik_text_nameField"))
        infoButton.setImage(Images.info_blueGreen, for: .normal)
    }
    
    func configureSubviews() {
        [title, blikLabelTextField, infoButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            infoButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            infoButton.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 20),
            
            blikLabelTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            blikLabelTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            blikLabelTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 24),
            blikLabelTextField.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configureStyling() {
        title.textColor = .lisboaGray
        title.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
    
    func configureTargets() {
        infoButton.addTarget(self, action: #selector(didTapLabelInfoButton), for: .touchUpInside)
    }
    
    func configureDelegates() {
        blikLabelTextField.textField.updatableDelegate = self
    }
    
    @objc func didTapLabelInfoButton(_ sender: UIButton) {
        let styledText: LocalizedStylableText = localized("pl_blik_tooltip_OtherSettingsDesc")
        BubbleLabelView.startWith(
            associated: sender,
            localizedStyleText: styledText,
            position: .bottom
        )
    }
}

extension BlikLabelSettingsContentView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateBlikLabel()
    }
}

