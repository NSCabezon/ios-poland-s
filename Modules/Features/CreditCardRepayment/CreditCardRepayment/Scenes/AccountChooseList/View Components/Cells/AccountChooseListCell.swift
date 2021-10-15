//
//  AccountChooseListCell.swift
//  CreditCardRepayment
//
//  Created by 186484 on 04/06/2021.
//

import UIKit
import PLUI
import UI

final class AccountChooseListCell: UITableViewCell {
        
    private let selectedCheckmarkImage: UIImage = {
        guard let selectedImage = UIImage(named: "radioBtnSelected",
                                          in: .module, compatibleWith: nil) else {
            return UIImage()
        }
        return selectedImage
    }()
    
    private let unselectedCheckmarkImage: UIImage = {
        guard let unselectedImage = UIImage(named: "radioBtnUnselected",
                                            in: .module, compatibleWith: nil) else {
            return UIImage()
        }
        return unselectedImage
    }()
    
    private lazy var checkmarkView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "radioBtnSelected", in: .module, compatibleWith: nil)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        // TODO: Move color to the separate module
        let viewColor = UIColor(red: 227.0 / 255.0, green: 228.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        view.backgroundColor = viewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 110.0 / 255.0, green: 110.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        let labelStylist = LabelStylist(textColor: labelColor,
                                        font: .santander(family: .micro, type: .semibold, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()

    private lazy var accountAmountLabel: UILabel = {
        let label = UILabel()
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 139.0 / 255.0, green: 139.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
        let labelStylist = LabelStylist(textColor: labelColor,
                                        font: .santander(family: .micro, type: .regular, size: 14),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    public static var identifier = "AccountChooseListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        self.backgroundColor = .clear
    }
    
    private func setupViews() {
        addSubview(checkmarkView)
        addSubview(separatorView)
        setupStackView()
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: checkmarkView.topAnchor, constant: Constants.checkmarkViewTop),
            leftAnchor.constraint(equalTo: checkmarkView.leftAnchor, constant: Constants.checkmarkViewLeft),
            checkmarkView.heightAnchor.constraint(equalToConstant: Constants.checkmarkViewHeight),
            checkmarkView.widthAnchor.constraint(equalToConstant: Constants.checkmarkViewWidth),
            
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.separatorViewLeft),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.separatorViewRight),
            bottomAnchor.constraint(equalTo: separatorView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(accountNameLabel)
        stackView.addArrangedSubview(accountAmountLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackViewTop),
            stackView.leftAnchor.constraint(equalTo: checkmarkView.rightAnchor, constant: Constants.stackViewLeft),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.stackViewRight),
            stackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.stackViewBottom)
        ])
    }
        
    private func setCellSelected() {
        self.checkmarkView.image = selectedCheckmarkImage
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 42.0 / 255.0, green: 131.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
        accountAmountLabel.textColor = labelColor
    }
    
    private func setCellUnselected() {
        self.checkmarkView.image = unselectedCheckmarkImage
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 139.0 / 255.0, green: 139.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
        accountAmountLabel.textColor = labelColor
    }
    
    func setup(with viewModel: AccountChooseListViewModel?) {
        guard let viewModel = viewModel else { return }
        accountNameLabel.text = viewModel.accountName
        accountAmountLabel.text = viewModel.accountAmount
        if viewModel.isSelected {
            self.setCellSelected()
        } else {
            self.setCellUnselected()
        }
    }

}

extension AccountChooseListCell {
    
    private struct Constants {
        static let checkmarkViewTop: CGFloat = -20.0
        static let checkmarkViewLeft: CGFloat = -19.0
        static let checkmarkViewHeight: CGFloat = 26.0
        static let checkmarkViewWidth: CGFloat = 26.0
        
        static let separatorViewHeight: CGFloat = 1.0
        static let separatorViewLeft: CGFloat = 19.0
        static let separatorViewRight: CGFloat = -14.0
        
        static let stackViewTop: CGFloat = 22.0
        static let stackViewLeft: CGFloat = 8.0
        static let stackViewRight: CGFloat = -15.0
        static let stackViewBottom: CGFloat = -25.0
    }
    
}
