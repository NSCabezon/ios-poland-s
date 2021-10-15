import UIKit
import UI
import PLUI
import Commons

protocol OtherBlikSettingsViewDelegate: AnyObject {
    func didUpdateBlikLabel()
    func didUpdateVisibility()
}

final class OtherBlikSettingsView: UIView {
    private let detailsLabelTitle = UILabel()
    private let detailsLabel = UILabel()
    private let separatorView = UIView()
    private let detailsButton = UIButton()
    private let blikLabelTitle = UILabel()
    private let blikLabelTextField = LisboaTextField()
    private let blikLabelInfoButton = UIButton()
    public weak var delegate: OtherBlikSettingsViewDelegate?
    
    public var blikCustomerLabel: String {
        blikLabelTextField.text ?? ""
    }
    
    public var isTransactionVisible: Bool {
        detailsButton.isSelected
    }
    
    public init() {
        super.init(frame: .zero)
        configureSubviews()
        configureStyling()
        configureContent()
        configureTargets()
        configureDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: OtherBlikSettingsViewModel) {
        blikLabelTextField.setText(viewModel.blikCustomerLabel)
        detailsButton.isSelected = viewModel.isTransactionVisible
    }
}

private extension OtherBlikSettingsView {
    func configureContent() {
        detailsLabelTitle.text = localized("pl_blik_text_transDetailsVisib")
        detailsLabel.text = localized("pl_blik_text_beforeLoginDetails")
        blikLabelTitle.text = localized("pl_blik_label_clientLabel")
        blikLabelTextField.setPlaceholder(localized("pl_blik_text_nameField"))
        blikLabelInfoButton.setImage(Images.info_blueGreen, for: .normal)
    }
    
    func configureSubviews() {
        addSubview(detailsLabelTitle)
        addSubview(separatorView)
        addSubview(detailsLabel)
        addSubview(detailsButton)
        addSubview(blikLabelTitle)
        addSubview(blikLabelTextField)
        addSubview(blikLabelInfoButton)
        
        detailsLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        blikLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        blikLabelTextField.translatesAutoresizingMaskIntoConstraints = false
        blikLabelInfoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailsLabelTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            detailsLabelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailsLabelTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: detailsLabelTitle.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: detailsLabelTitle.leadingAnchor),
            
            detailsButton.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor),
            detailsButton.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor),
            detailsButton.trailingAnchor.constraint(equalTo: detailsLabelTitle.trailingAnchor),
            detailsButton.widthAnchor.constraint(equalToConstant: 43),
            detailsButton.heightAnchor.constraint(equalToConstant: 28),
            
            separatorView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 32),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            blikLabelTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 24),
            blikLabelTitle.leadingAnchor.constraint(equalTo: detailsLabelTitle.leadingAnchor),
            
            blikLabelInfoButton.centerYAnchor.constraint(equalTo: blikLabelTitle.centerYAnchor),
            blikLabelInfoButton.leadingAnchor.constraint(equalTo: blikLabelTitle.trailingAnchor, constant: 8),
            blikLabelInfoButton.widthAnchor.constraint(equalToConstant: 20),
            blikLabelInfoButton.heightAnchor.constraint(equalToConstant: 20),
            
            blikLabelTextField.topAnchor.constraint(equalTo: blikLabelInfoButton.bottomAnchor, constant: 8),
            blikLabelTextField.leadingAnchor.constraint(equalTo: detailsLabelTitle.leadingAnchor),
            blikLabelTextField.trailingAnchor.constraint(equalTo: detailsLabelTitle.trailingAnchor),
            blikLabelTextField.heightAnchor.constraint(equalToConstant: 48),
            blikLabelTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureStyling() {
        detailsLabelTitle.textColor = .lisboaGray
        detailsLabelTitle.font = .santander(
            family: .text,
            type: .regular,
            size: 14
        )
        
        detailsLabel.textColor = .lisboaBrown
        detailsLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 16
        )
        
        blikLabelTitle.textColor = .lisboaGray
        blikLabelTitle.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        separatorView.backgroundColor = .mediumSkyGray
        
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 20)
        formatter.setAllowOnlyCharacters(CharacterSet(charactersIn: OtherBlikSettingsAllowedCharacters.blikLabel.rawValue))
        blikLabelTextField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: formatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .alphabet
                    }
                )
            )
        )
        
        detailsButton.setImage(Assets.image(named: "icnOnSwich"), for: .selected)
        detailsButton.setImage(Assets.image(named: "icnOffSwich"), for: .normal)
    }
    
    func configureTargets() {
        detailsButton.addTarget(self, action: #selector(didTapDetailsButton), for: .touchUpInside)
        blikLabelInfoButton.addTarget(self, action: #selector(didTapLabelInfoButton), for: .touchUpInside)
    }
    
    func configureDelegates() {
        blikLabelTextField.updatableDelegate = self
    }

    @objc func didTapDetailsButton() {
        delegate?.didUpdateVisibility()
        detailsButton.isSelected.toggle()
    }
    
    @objc func didTapLabelInfoButton() {
        let bubble = BubbleLabelView(associated: blikLabelInfoButton,
                                     text: localized("pl_blik_tooltip_ClientLabelDesc"),
                                     position: .bottom)
        window?.addSubview(bubble)
        addCloseCourtain()
    }
    
    func addCloseCourtain() {
        let curtain = UIView(frame: UIScreen.main.bounds)
        curtain.backgroundColor = UIColor.clear
        curtain.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBubble(_:))))
        curtain.isUserInteractionEnabled = true
        window?.addSubview(curtain)
    }
    
    @objc func closeBubble(_ sender: UITapGestureRecognizer) {
        window?.subviews.forEach { ($0 as? BubbleLabelView)?.dismiss() }
        sender.view?.removeFromSuperview()
    }
}

extension OtherBlikSettingsView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateBlikLabel()
    }
}