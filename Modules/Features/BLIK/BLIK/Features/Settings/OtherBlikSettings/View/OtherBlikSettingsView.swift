import UIKit
import UI
import PLUI
import CoreFoundationLib

protocol OtherBlikSettingsViewDelegate: AnyObject {
    func didUpdateVisibility()
    func didTapBlikLabelEditButton()
}

final class OtherBlikSettingsView: UIView {
    private let transactionVisibilityTitle = UILabel()
    private let transactionVisibilityDescription = UILabel()
    private let transactionVisibilityToggle = UIButton()
    
    private let blikLabelHeaderContainer = UIView()
    private let blikLabelHeaderTitle = UILabel()
    private let blikLabelInfoButton = UIButton()
    private let blikLabelEditButton = UIButton()
    
    private let blikLabelContainer = UIView()
    private let blikLabel = UILabel()
    
    public weak var delegate: OtherBlikSettingsViewDelegate?
    public var isTransactionVisible: Bool {
        transactionVisibilityToggle.isSelected
    }
    
    public init() {
        super.init(frame: .zero)
        configureSubviews()
        configureStyling()
        configureContent()
        configureTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: OtherBlikSettingsViewModel) {
        transactionVisibilityToggle.isSelected = viewModel.isTransactionVisible
        blikLabel.text = viewModel.blikCustomerLabel
    }
}

private extension OtherBlikSettingsView {
    func configureContent() {
        transactionVisibilityTitle.text = localized("pl_blik_title_detailsBeforeLogin")
        transactionVisibilityDescription.text = localized("pl_blik_text_detailsVisibInfo")
        blikLabelHeaderTitle.text = localized("pl_blik_label_clientLabel")
        blikLabelEditButton.setTitle(localized("generic_button_change"), for: .normal)
        blikLabelEditButton.setImage(PLAssets.image(named: "editIcon"), for: .normal)
        blikLabelInfoButton.setImage(Images.info_blueGreen, for: .normal)
    }
    
    func configureSubviews() {
        [
            transactionVisibilityTitle,
            transactionVisibilityDescription,
            transactionVisibilityToggle,
            blikLabelHeaderContainer,
            blikLabelContainer,
            blikLabelHeaderTitle,
            blikLabelInfoButton,
            blikLabelEditButton,
            blikLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            transactionVisibilityTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            transactionVisibilityTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            transactionVisibilityToggle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            transactionVisibilityToggle.leadingAnchor.constraint(equalTo: transactionVisibilityTitle.trailingAnchor, constant: 24),
            transactionVisibilityToggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transactionVisibilityToggle.heightAnchor.constraint(equalToConstant: 28),
            transactionVisibilityToggle.widthAnchor.constraint(equalToConstant: 43),
            
            transactionVisibilityDescription.topAnchor.constraint(equalTo: transactionVisibilityTitle.bottomAnchor, constant: 4),
            transactionVisibilityDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transactionVisibilityDescription.trailingAnchor.constraint(equalTo: transactionVisibilityToggle.leadingAnchor, constant: -24),
            
            blikLabelHeaderContainer.topAnchor.constraint(equalTo: transactionVisibilityDescription.bottomAnchor, constant: 32),
            blikLabelHeaderContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            blikLabelHeaderContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            blikLabelHeaderTitle.topAnchor.constraint(equalTo: blikLabelHeaderContainer.topAnchor, constant: 8),
            blikLabelHeaderTitle.leadingAnchor.constraint(equalTo: blikLabelHeaderContainer.leadingAnchor, constant: 24),
            blikLabelHeaderTitle.bottomAnchor.constraint(equalTo: blikLabelHeaderContainer.bottomAnchor, constant: -8),
            
            blikLabelInfoButton.leadingAnchor.constraint(equalTo: blikLabelHeaderTitle.trailingAnchor, constant: 8),
            blikLabelInfoButton.centerYAnchor.constraint(equalTo: blikLabelHeaderTitle.centerYAnchor),
            blikLabelInfoButton.heightAnchor.constraint(equalToConstant: 20),
            blikLabelInfoButton.widthAnchor.constraint(equalToConstant: 20),
            
            blikLabelEditButton.trailingAnchor.constraint(equalTo: blikLabelHeaderContainer.trailingAnchor, constant: -24),
            blikLabelEditButton.centerYAnchor.constraint(equalTo: blikLabelHeaderTitle.centerYAnchor),
            
            blikLabelContainer.topAnchor.constraint(equalTo: blikLabelHeaderContainer.bottomAnchor, constant: 16),
            blikLabelContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            blikLabelContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            blikLabelContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
            
            blikLabel.topAnchor.constraint(equalTo: blikLabelContainer.topAnchor, constant: 12),
            blikLabel.leadingAnchor.constraint(equalTo: blikLabelContainer.leadingAnchor, constant: 16),
            blikLabel.trailingAnchor.constraint(equalTo: blikLabelContainer.trailingAnchor, constant: -16),
            blikLabel.bottomAnchor.constraint(equalTo: blikLabelContainer.bottomAnchor, constant: -12)
        ])
    }
    
    func configureStyling() {
        transactionVisibilityTitle.numberOfLines = 0
        transactionVisibilityTitle.textColor = .lisboaGray
        transactionVisibilityTitle.font = .santander(
            family: .text,
            type: .bold,
            size: 16
        )
        
        transactionVisibilityDescription.numberOfLines = 0
        transactionVisibilityDescription.textColor = .lisboaGray
        transactionVisibilityDescription.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        
        transactionVisibilityToggle.setImage(Assets.image(named: "icnOnSwich"), for: .selected)
        transactionVisibilityToggle.setImage(Assets.image(named: "icnOffSwich"), for: .normal)
        
        blikLabelEditButton.imageView?.contentMode = .scaleAspectFit
        blikLabelEditButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: -4, bottom: 2, right: 0)
        blikLabelEditButton.setTitleColor(.darkTorquoise, for: .normal)
        blikLabelEditButton.titleLabel?.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
        
        blikLabelHeaderContainer.backgroundColor = .skyGray
        
        blikLabelHeaderTitle.numberOfLines = 1
        blikLabelHeaderTitle.textColor = .lisboaGray
        blikLabelHeaderTitle.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        blikLabelContainer.backgroundColor = .lightSanGray
        
        blikLabel.numberOfLines = 1
        blikLabel.textColor = .brownishGray
        blikLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 16
        )
    }
    
    func configureTargets() {
        transactionVisibilityToggle.addTarget(self, action: #selector(didTaptransactionVisibilityToggle), for: .touchUpInside)
        blikLabelInfoButton.addTarget(self, action: #selector(didTapLabelInfoButton), for: .touchUpInside)
        blikLabelEditButton.addTarget(self, action: #selector(didTapLabelEditButton), for: .touchUpInside)
    }

    @objc func didTaptransactionVisibilityToggle() {
        transactionVisibilityToggle.isSelected.toggle()
        delegate?.didUpdateVisibility()
    }
    
    @objc func didTapLabelInfoButton(_ sender: UIButton) {
        let styledText: LocalizedStylableText = localized("pl_blik_tooltip_OtherSettingsDesc")
        BubbleLabelView.startWith(
            associated: sender,
            localizedStyleText: styledText,
            position: .bottom
        )
    }
    
    @objc func didTapLabelEditButton() {
        delegate?.didTapBlikLabelEditButton()
    }
}
