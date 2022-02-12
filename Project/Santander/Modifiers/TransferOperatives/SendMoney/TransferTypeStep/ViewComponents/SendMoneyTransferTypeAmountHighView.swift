//
//  SendMoneyTransferTypeAmountHighView.swift
//  Santander
//
//  Created by Angel Abad Perez on 19/10/21.
//

import UI
import UIOneComponents
import CoreFoundationLib

protocol SendMoneyTransferTypeAmountHighViewDelegate: AnyObject {
    func didTapActionButton()
}

final class SendMoneyTransferTypeAmountHighView: UIView {
    private enum Constants {
        enum Icon {
            static let name: String = "oneIcnAlert"
        }
        enum TitleLabel {
            static let textKey: String = "sendMoney_title_amountHigh"
            static let bottomSpace: CGFloat = 20.0
        }
        enum DescriptionLabel {
            static let textKey: String = "sendMoney_text_amountHigh"
        }
        enum AcceptButton {
            static let titleKey: String = "generic_button_accept"
        }
    }
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var actionButton: OneFloatingButton!
    
    weak var delegate: SendMoneyTransferTypeAmountHighViewDelegate?
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension SendMoneyTransferTypeAmountHighView {
    func setupView() {
        self.xibSetup()
        self.configureIconImageView()
        self.configureActionButton()
        self.configureLabels()
        self.setAccessibilityIdentifiers()
    }
    
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view?.frame = self.bounds
        self.addSubview(self.view ?? UIView())
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
    
    func configureIconImageView() {
        self.iconImageView.image = Assets.image(named: Constants.Icon.name)?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.tintColor = .oneBlack
    }
    
    func configureLabels() {
        self.titleLabel.font = .typography(fontName: .oneH300Bold)
        self.titleLabel.textColor = .oneLisboaGray
        self.titleLabel.configureText(withKey: Constants.TitleLabel.textKey)
        self.titleLabel.sizeToFit()
        self.descriptionLabel.font = .typography(fontName: .oneB400Regular)
        self.descriptionLabel.textColor = .oneLisboaGray
        self.descriptionLabel.configureText(withKey: Constants.DescriptionLabel.textKey)
        self.descriptionLabel.sizeToFit()
    }
    
    func configureActionButton() {
        self.actionButton.isEnabled = true
        self.actionButton.configureWith(type: .primary,
                                        size: .medium(
                                            OneFloatingButton.ButtonSize.MediumButtonConfig(
                                                title: localized(Constants.AcceptButton.titleKey),
                                                icons: .none,
                                                fullWidth: false
                                            )
                                        ),
                                        status: .ready)
        self.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    func setAccessibilityIdentifiers() {
        self.titleLabel.accessibilityIdentifier = Constants.TitleLabel.textKey
        self.descriptionLabel.accessibilityIdentifier = Constants.DescriptionLabel.textKey
    }
    
    @objc func didTapActionButton() {
        self.delegate?.didTapActionButton()
    }
}
