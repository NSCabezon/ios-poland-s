//
//  TaxTransferFormContainerView.swift
//  TaxTransfer
//
//  Created by 185167 on 13/12/2021.
//

import UI
import PLUI

protocol TaxTransferFormContainerViewDelegate: AnyObject {
    func scrollToBottom()
}

final class TaxTransferFormContainerView: UIView {
    private let stackView = UIStackView()
    private let accountSelector = TaxTransferAccountSelectorView()
    private let taxPayerSelector = TaxTransferPayerSelectorView()
    private let taxAuthoritySelector = TaxTransferAuthoritySelectorView()
    private let amountField = TaxTransferAmountFieldView()
    private let obligationIdentifierField = TaxTransferObligationIdentifierFieldView()
    private let dateSelector: TaxTransferDateSelectorView
    
    private weak var delegate: TaxTransferFormContainerViewDelegate?
    
    init(
        configuration: DateSelectorConfiguration,
        delegate: TaxTransferFormContainerViewDelegate
    ) {
        self.dateSelector = TaxTransferDateSelectorView(
            configuration: configuration
        )
        self.delegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
}

private extension TaxTransferFormContainerView {
    func setUp() {
        configureStackView()
        configureSubviews()
        configureDateSelector()
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
    }
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            accountSelector,
            taxPayerSelector,
            taxAuthoritySelector,
            amountField,
            obligationIdentifierField,
            dateSelector
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
    
    func configureDateSelector() {
        dateSelector.delegate = self
    }
}

extension TaxTransferFormContainerView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        if option == .anotherDay {
            delegate?.scrollToBottom()
        }
    }
}
