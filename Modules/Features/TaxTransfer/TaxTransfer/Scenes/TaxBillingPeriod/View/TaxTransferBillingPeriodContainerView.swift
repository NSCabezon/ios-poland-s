//
//  TaxTransferBillingPeriodContainerView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import UI
import CoreFoundationLib

protocol TaxTransferBillingPeriodFormDelegate: AnyObject {
    func didTapPeriodNumber()
    func didTapPeriodType()
    func didEndEditing()
}

final class TaxTransferBillingPeriodContainerView: UIView {
    weak var delegate: TaxTransferBillingPeriodFormDelegate?
    
    private let stackView = UIStackView()
    private let yearSelector = TaxTransferBillingPeriodInputView(
        with: localized("pl_taxTransfer_tab_year")
    )
    private let daySelector = TaxTransferBillingPeriodInputView(
        with: "#Numer okresu (DDMM)"
    )
    private let periodSelector = TaxTransferBillingPeriodSelectorView(
        with: localized("pl_taxTransfer_text_periodType")
    )
    private let periodNumberSelector = TaxTransferBillingPeriodSelectorView(
        with: localized("pl_taxTransfer_text_periodNumber")
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel>,
        onTap: @escaping () -> Void
    ) {
        periodSelector.configurePeriod(with: viewModel, onTap: onTap)
        
        switch viewModel {
        case let .selected(viewModel):
            periodNumberSelector.isHidden = !viewModel.periodType.shouldChoosePeriodNumber
            daySelector.isHidden = viewModel.periodType != .day
        default:
            periodNumberSelector.isHidden = true
        }
    }
    
    func setUp(
        with viewModel: Selectable<Int>,
        onTap: @escaping () -> Void
    ) {
        periodNumberSelector.configurePeriodNumber(
            with: viewModel,
            onTap: onTap
        )
    }
    
    func getForm() -> TaxTransferBillingPeriodForm? {
        let year = yearSelector.getInputText()
        let periodType = periodSelector.getPeriodType()
        let periodNumber = periodNumberSelector.getPeriodNumber()
        let dayNumber = daySelector.getInputText()
    
        guard let periodType = periodType else {
            return nil
        }

        if periodType.shouldChoosePeriodNumber, periodNumber == nil {
            return nil
        }

        if periodType == .day, dayNumber.isEmpty {
            return nil
        }
        
        return TaxTransferBillingPeriodForm(
            year: year,
            periodType: periodType,
            day: dayNumber,
            periodNumber: periodNumber
        )
    }
    
    func showInvalidFormMessages(_ messages: InvalidTaxBillingPeriodFormMessage) {
        if messages.invalidDayMessage == nil {
            daySelector.hideError()
        } else {
            daySelector.showError(messages.invalidDayMessage)
        }
        
        if messages.invalidYearMessage == nil {
            yearSelector.hideError()
        } else {
            yearSelector.showError(messages.invalidYearMessage)
        }
    }
    
    func clearValidationMessages() {
        [yearSelector, daySelector].forEach {
            $0.hideError()
        }
    }
}

extension TaxTransferBillingPeriodContainerView: TaxTransferBillingPeriodInputDelegate {
    func didEndEditing() {
        delegate?.didEndEditing()
    }
}

private extension TaxTransferBillingPeriodContainerView {
    func setUp() {
        configureStackView()
        configureSubviews()
        configureDelegates()
        configureSelectors()
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
        
        [yearSelector,
         periodSelector,
         periodNumberSelector,
         daySelector
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
    
    func configureDelegates() {
        yearSelector.delegate = self
        daySelector.delegate = self
    }
    
    func configureSelectors() {
        periodSelector.configurePeriod(with: .unselected, onTap: didTapPeriodType)
        periodNumberSelector.configurePeriodNumber(with: .unselected, onTap: didTapPeriodNumber)
        
        periodNumberSelector.isHidden = true
        daySelector.isHidden = true
    }
    
    @objc func didTapPeriodType() {
        delegate?.didTapPeriodType()
    }
    
    @objc func didTapPeriodNumber() {
        delegate?.didTapPeriodNumber()
    }
}
