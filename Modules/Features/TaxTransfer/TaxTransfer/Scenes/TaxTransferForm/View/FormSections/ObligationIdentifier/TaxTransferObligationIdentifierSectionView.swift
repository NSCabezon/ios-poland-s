//
//  TaxTransferObligationIdentifierSectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 29/12/2021.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons

final class TaxTransferObligationIdentifierSectionView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let obligationIdentifier = LisboaTextFieldWithErrorView()
    private let charactersLimit = UILabel()
    weak var textFieldDelegate: UpdatableTextFieldDelegate? {
        didSet {
            obligationIdentifier.textField.updatableDelegate = textFieldDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(with viewModel: TaxTransferFormViewModel) {
        obligationIdentifier.textField.setText(viewModel.obligationIdentifier)
    }
    
    func getIdentifier() -> String {
        return obligationIdentifier.textField.text ?? ""
    }
    
    func setInvalidFieldMessage(_ message: String?) {
        if let message = message {
            obligationIdentifier.showError(message)
        } else {
            obligationIdentifier.hideError()
        }
    }
}

private extension TaxTransferObligationIdentifierSectionView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        [obligationIdentifier, charactersLimit].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            obligationIdentifier.topAnchor.constraint(equalTo: containerView.topAnchor),
            obligationIdentifier.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            obligationIdentifier.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            charactersLimit.topAnchor.constraint(equalTo: obligationIdentifier.bottomAnchor, constant: 8),
            charactersLimit.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            charactersLimit.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            charactersLimit.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        let infoButtonTextKey = "pl_taxTransfer_tooltip_financialObligationId"
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: localized("pl_taxTransfer_tooltip_financialObligationIdTitle"),
            infoButtonMode: .enabled(infoButtonTextKey)
        )
    }
    
    func configureStyling() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 40)
        formatter.setAllowOnlyCharacters(.ascii)
        obligationIdentifier.textField.placeholder = localized("pl_taxTransfer_label_financialObligationId")
        obligationIdentifier.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: formatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .asciiCapable
                    }
                )
            )
        )
        
        charactersLimit.text = localized("pl_taxTransfer_validation_maximumLength")
        charactersLimit.textColor = .brownishGray
        charactersLimit.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
}
