//
//  SendMoneyTransferTypeErrorView.swift
//  Santander
//
//  Created by Angel Abad Perez on 19/10/21.
//

import UI
import UIOneComponents
import CoreFoundationLib
import UIKit

protocol SendMoneyTransferTypeErrorViewDelegate: AnyObject {
    func didTapActionButton(viewController: UIViewController?)
}

struct SendMoneyTransferTypeErrorViewModel {
    let titleKey: String
    let subtitleKey: String
    let buttonKey: String
    var imageColor: UIColor = .oneBlack
}

final class SendMoneyTransferTypeErrorView: UIView {
    private enum Constants {
        enum Icon {
            static let name: String = "oneIcnAlert"
        }
        enum TitleLabel {
            static let bottomSpace: CGFloat = 20.0
        }
    }
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var actionButton: OneFloatingButton!
    
    weak var delegate: SendMoneyTransferTypeErrorViewDelegate?
    private var view: UIView?
    private var viewModel: SendMoneyTransferTypeErrorViewModel?
    
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
    
    func setupViewModel(_ viewModel: SendMoneyTransferTypeErrorViewModel) {
        self.titleLabel.configureText(withKey: viewModel.titleKey)
        self.descriptionLabel.configureText(withKey: viewModel.subtitleKey)
        self.iconImageView.tintColor = viewModel.imageColor
        self.configureActionButton(viewModel: viewModel)
        self.setAccessibilityIdentifiers(viewModel: viewModel)
    }
}

private extension SendMoneyTransferTypeErrorView {
    func setupView() {
        self.xibSetup()
        self.configureIconImageView()
        self.configureLabels()
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
        self.titleLabel.sizeToFit()
        self.descriptionLabel.font = .typography(fontName: .oneB400Regular)
        self.descriptionLabel.textColor = .oneLisboaGray
        self.descriptionLabel.sizeToFit()
    }
    
    func configureActionButton(viewModel: SendMoneyTransferTypeErrorViewModel) {
        self.actionButton.isEnabled = true
        self.actionButton.configureWith(type: .primary,
                                        size: .medium(
                                            OneFloatingButton.ButtonSize.MediumButtonConfig(
                                                title: localized(viewModel.buttonKey),
                                                icons: .none,
                                                fullWidth: false
                                            )
                                        ),
                                        status: .ready)
        self.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    func setAccessibilityIdentifiers(viewModel: SendMoneyTransferTypeErrorViewModel) {
        self.titleLabel.accessibilityIdentifier = viewModel.titleKey
        self.descriptionLabel.accessibilityIdentifier = viewModel.subtitleKey
    }
    
    @objc func didTapActionButton() {
        self.delegate?.didTapActionButton(viewController: self.viewContainingController())
    }
}
