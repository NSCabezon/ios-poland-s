//
//  AddTaxPayerFormContainerView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

protocol AddTaxPayerFormViewDelegate: AnyObject {
    func didEndEditing()
}

final class AddTaxPayerFormContainerView: UIView {
    weak var delegate: AddTaxPayerFormViewDelegate?
    
    private let stackView = UIStackView()
    private let identifierSelector = AddTaxPayerIdentifierSelectorView()
    private let identifierNumber = AddTaxPayerInfoView(
        with: AddTaxPayerFormConfiguration(
            info: "#Numer identyfikatora",
            charactersLimit: nil)
    )
    
    private let payerName = AddTaxPayerInfoView(
        with: AddTaxPayerFormConfiguration(
            info: "#Nazwa płatnika",
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
    
    func getForm() -> AddTaxPayerForm {
        let identifierNumber = identifierNumber.getInputText()
        let payerName = payerName.getInputText()
        
        return AddTaxPayerForm(
            payerName: payerName,
            identifierNumber: identifierNumber,
            identifierType: .PESEL // TODO: identifier type will be handled in next pr
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
    
    private func setUp() {
        configureStackView()
        configureSubviews()
        configureDelegates()
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
}

extension AddTaxPayerFormContainerView: AddTaxPayerInfoViewDelegate {
    func didEndEditing() {
        delegate?.didEndEditing()
    }
}
