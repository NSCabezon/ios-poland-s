//
//  TaxTransferSelectedPeriodView.swift
//  TaxTransfer
//
//  Created by 187831 on 08/03/2022.
//

import PLUI
import UI
import CoreFoundationLib

final class TaxTransferSelectedBillingPeriodView: UIView {
    private let tappableCard = TappableControl()
    private let periodStackView = UIStackView()
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(
        viewModel: TaxTransferFormViewModel.TaxBillingPeriodViewModel,
        onTap: @escaping () -> Void
    ) {
        topLabel.text = localized("pl_taxTransfer_tab_year") + ": " + viewModel.year
        bottomLabel.isHidden = viewModel.periodType == .year
        
        tappableCard.onTap = onTap
        
        if viewModel.periodType != .year {
            bottomLabel.text = viewModel.periodType.name + ": " + "\(viewModel.periodNumber ?? 0)"
        }
    }
}

private extension TaxTransferSelectedBillingPeriodView {
    func setUp() {
        configureSubviews()
        configureLabels()
        configureStyling()
    }
    
    func configureSubviews() {
        addSubview(periodStackView)
        periodStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [topLabel,
         bottomLabel].forEach {
            periodStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
         }
        
        periodStackView.distribution = .fill
        periodStackView.axis = .vertical
        
        addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        bringSubviewToFront(tappableCard)
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: topAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            periodStackView.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 15),
            periodStackView.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 15),
            periodStackView.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: 15),
            periodStackView.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -15)
        ])
    }
    
    func configureLabels() {
        [topLabel,
         bottomLabel].forEach {
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    func configureStyling() {
        tappableCard.layer.masksToBounds = false
        tappableCard.backgroundColor = .clear
        tappableCard.drawRoundedBorderAndShadow(
            with: .init(color: .lightSanGray, opacity: 0.5, radius: 4, withOffset: 0, heightOffset: 2),
            cornerRadius: 5,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
        
        topLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
        
        bottomLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
    }
}
