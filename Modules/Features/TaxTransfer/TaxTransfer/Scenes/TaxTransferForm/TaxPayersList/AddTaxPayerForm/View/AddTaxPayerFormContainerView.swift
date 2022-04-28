//
//  AddTaxPayerFormContainerView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

import CoreFoundationLib

protocol AddTaxPayerFormViewDelegate: AnyObject {
    func didTapIdentifiersSelector()
    func didUpdateText()
}

final class AddTaxPayerFormContainerView: UIView {
    weak var delegate: AddTaxPayerFormViewDelegate?
    
    private let stackView = UIStackView()
    private let identifierSelector = AddTaxPayerIdentifierSelectorView()
    private let identifierNumber = AddTaxPayerInfoView(
        with: AddTaxPayerFormConfiguration(
            info: localized("pl_taxTransfer_text_identifierNumber"),
            charactersLimit: nil)
    )
    
    private let payerName = AddTaxPayerInfoView(
        with: AddTaxPayerFormConfiguration(
            info: localized("pl_taxTransfer_text_payeesName"),
            charactersLimit: 50)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getForm() -> AddTaxPayerForm? {
        let identifierNumber = identifierNumber.getInputText()
        let payerName = payerName.getInputText()
        
        guard let identifier = identifierSelector.getIdentifierType() else {
            return nil
        }
        
        return AddTaxPayerForm(
            payerName: payerName,
            identifierNumber: identifierNumber,
            identifierType: identifier
        )
    }
    
    func showInvalidFormMessages(_ messages: InvalidAddTaxPayerFormMessages) {
        if messages.invalidIdentifierNumberMessage == nil {
            identifierNumber.hideError()
        } else {
            identifierNumber.showError(messages.invalidIdentifierNumberMessage)
        }
        
        if messages.invalidNameMessage == nil {
            payerName.hideError()
        } else {
            payerName.showError(messages.invalidNameMessage)
        }
    }
    
    func clearValidationMessages() {
        identifierNumber.hideError()
        payerName.hideError()
    }
    
    func setUp(with identifier: Selectable<TaxIdentifierType>) {
        identifierSelector.configure(
            with: identifier,
            onTap: didTapIdentifiersSelector
        )
        identifierNumber.clear()
    }
    
    private func setUp() {
        configureStackView()
        configureSubviews()
        configureDelegates()
        configureIdentifiersSelector()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
    }
    
    private func configureSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [identifierSelector,
         identifierNumber,
         payerName
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureDelegates() {
        identifierNumber.delegate = self
        payerName.delegate = self
    }
    
    private func configureIdentifiersSelector() {
        identifierSelector.configure(
            with: .unselected,
            onTap: didTapIdentifiersSelector
        )
    }
    
    private func didTapIdentifiersSelector() {
        delegate?.didTapIdentifiersSelector()
    }
}

extension AddTaxPayerFormContainerView: AddTaxPayerInfoViewDelegate {
    func didUpdateText() {
        delegate?.didUpdateText()
    }
}
