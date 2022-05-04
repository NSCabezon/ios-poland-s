//
//  SummaryFieldView.swift
//  ScanAndPay
//
//  Created by 188216 on 11/04/2022.
//

import UIKit

final class SummaryFieldView: UIView {
    // MARK: Properties
    
    private let mainStackView = UIStackView()
    private let labelsStackView = UIStackView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let separatorView = SeparatorView()
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: Configuration
    
    func configure(with viewModel: SummaryFieldViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        separatorView.isHidden = !viewModel.showSeparator
        if viewModel.isValueBold {
            valueLabel.font = .santander(family: .micro, type: .bold, size: 14.0)
        }
    }

    private func setUp() {
        addSubviews()
        setUpLayout()
        prepareStyles()
    }

    private func addSubviews() {
        addSubviewConstraintToEdges(mainStackView)
        mainStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(valueLabel)
        mainStackView.addArrangedSubview(separatorView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 2
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        valueLabel.setContentHuggingPriority(.required, for: .vertical)
        valueLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func prepareStyles() {
        titleLabel.font = .santander(family: .text, type: .regular, size: 14.0)
        titleLabel.textColor = .lisboaGray
        
        valueLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        valueLabel.textColor = .lisboaGray
    }
}
