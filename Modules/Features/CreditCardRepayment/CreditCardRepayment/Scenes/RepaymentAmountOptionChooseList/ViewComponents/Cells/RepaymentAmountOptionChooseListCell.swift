//
//  RepaymentAmountOptionChooseListCell.swift
//  CreditCardRepayment
//
//  Created by 186484 on 07/06/2021.
//

import UIKit
import PLUI
import UI

final class RepaymentAmountOptionChooseListCell: UITableViewCell {
    
    private let selectedCheckmarkImage: UIImage = {
        return Images.radioBtnSelected
    }()
    
    private let unselectedCheckmarkImage: UIImage = {
        return Images.radioBtnUnselected
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.radioBtnSelected
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        // TODO: Move color to the separate module
        let viewColor = UIColor(red: 227.0 / 255.0, green: 228.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        view.backgroundColor = viewColor
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6.0
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let repaymentNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 110.0 / 255.0, green: 110.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        let labelStylist = LabelStylist(textColor: labelColor,
                                        font: .santander(family: .micro, type: .bold, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private let repaymentValueLabel: UILabel = {
        let label = UILabel()
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 139.0 / 255.0, green: 139.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
        let labelStylist = LabelStylist(textColor: labelColor,
                                        font: .santander(family: .micro, type: .regular, size: 14),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    public static var identifier = "RepaymentAmountOptionChooseListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubviews()
        prepareLayout()
    }
    
    private func addSubviews() {
        addSubview(checkmarkView)
        addSubview(separatorView)
        stackView.addArrangedSubview(repaymentNameLabel)
        stackView.addArrangedSubview(repaymentValueLabel)
        addSubview(stackView)
    }
    
    private func prepareLayout() {
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: checkmarkView.topAnchor, constant: -20.0),
            leftAnchor.constraint(equalTo: checkmarkView.leftAnchor, constant: -19.0),
            checkmarkView.heightAnchor.constraint(equalToConstant: 26.0),
            checkmarkView.widthAnchor.constraint(equalToConstant: 26.0),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 19.0),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -14.0),
            bottomAnchor.constraint(equalTo: separatorView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 22.0),
            stackView.leftAnchor.constraint(equalTo: checkmarkView.rightAnchor, constant: 8.0),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15.0),
            stackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -25.0)
        ])
    }
    
    private func setCellSelected() {
        self.checkmarkView.image = selectedCheckmarkImage
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 42.0 / 255.0, green: 131.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
        repaymentValueLabel.textColor = labelColor
    }
    
    private func setCellUnselected() {
        self.checkmarkView.image = unselectedCheckmarkImage
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 139.0 / 255.0, green: 139.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
        repaymentValueLabel.textColor = labelColor
    }
    
    func setup(with viewModel: RepaymentAmountOptionChooseListViewModel) {
        repaymentNameLabel.text = viewModel.repaymentName
        repaymentValueLabel.text = viewModel.repaymentValue
        if viewModel.isSelected {
            self.setCellSelected()
        } else {
            self.setCellUnselected()
        }
    }
    
}
