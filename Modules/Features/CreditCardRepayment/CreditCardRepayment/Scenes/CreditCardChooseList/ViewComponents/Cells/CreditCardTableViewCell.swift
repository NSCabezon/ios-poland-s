//
//  CreditCardTableViewCell.swift
//  CreditCardRepayment
//
//  Created by 186482 on 02/06/2021.
//

import UIKit
import UI
import PLUI

private extension CreditCardTableViewCell {
    
    struct Constant {
        static let shadowOffsetY: CGFloat = 4.0
        static let shadowOffsetX: CGFloat = 3.0
    }
    
}

final class CreditCardTableViewCell: UITableViewCell {
    
    private lazy var viewsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var creditCardNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .greyishBrown,
                                        font: .santander(family: .micro, type: .bold, size: 16.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private lazy var creditCardLastDigitsLabel: UILabel = {
        let label = UILabel()
        let labelStylist = LabelStylist(textColor: .suvaGrey,
                                        font: .santander(family: .micro, type: .regular, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    public static var identifier = "CreditCardTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupViewsContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupViewsContainer()
    }
    
    private func setupViewsContainer() {
        addSubview(viewsContainer)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: viewsContainer.topAnchor, constant: -18.0),
            leftAnchor.constraint(equalTo: viewsContainer.leftAnchor),
            rightAnchor.constraint(equalTo: viewsContainer.rightAnchor, constant: Constant.shadowOffsetX),
            bottomAnchor.constraint(equalTo: viewsContainer.bottomAnchor)
        ])
        viewsContainer.drawRoundedAndShadowedNew(widthOffSet: Constant.shadowOffsetX,
                                                 heightOffSet: Constant.shadowOffsetY)
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(creditCardNameLabel)
        stackView.addArrangedSubview(creditCardLastDigitsLabel)
        viewsContainer.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewsContainer.topAnchor, constant: 13.0),
            stackView.leftAnchor.constraint(equalTo: viewsContainer.leftAnchor, constant: 15.0),
            stackView.rightAnchor.constraint(equalTo: viewsContainer.rightAnchor, constant: 15.0),
            stackView.bottomAnchor.constraint(equalTo: viewsContainer.bottomAnchor, constant: -16.0)
        ])
    }
    
    func setup(with viewModel: CreditCardChooseListViewModel) {
        creditCardNameLabel.text = viewModel.creditCardName
        creditCardLastDigitsLabel.text = viewModel.lastCreditCardDigits
        
        viewsContainer.drawRoundedAndShadowedNew(
            borderColor: .mediumSkyGray,
            widthOffSet: Constant.shadowOffsetX,
            heightOffSet: Constant.shadowOffsetY
        )
    }
    
}
