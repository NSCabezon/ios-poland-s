//
//  PaymentAmountSelectionView.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/12/2021.
//

import UIKit
import UI
import PLUI
import CoreFoundationLib
import PLCommons
import SANLegacyLibrary

protocol PaymentAmontSelectionViewDelegate: AnyObject {
    func didSelectTopUpAmount(_ amount: TopUpAmount)
}

final class PaymentAmountSelectionView: UIView {
    // MARK: Views
    
    private let mainStackView = UIStackView()
    private let amountContainer = UIStackView()
    private let amountHeaderLabel = FormHeaderLabel()
    private let amountCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let otherAmountContainer = UIStackView()
    private let otherAmountHeaderLabel = FormHeaderLabel()
    private let otherAmountTextField = LisboaTextFieldWithErrorView()
    private let currencyAccessoryView = CurrencyLabel()
    private lazy var collectionViewHeightConstraint = amountCollectionView.heightAnchor.constraint(equalToConstant: 0.0)
    
    
    // MARK: Properties
    
    weak var delegate: PaymentAmontSelectionViewDelegate?
    private let cellReuseIdentifier = "PaymentAmountCollectionViewCell"
    private let cellSpacing: CGFloat = 16.0
    private let numberOfColumns = 3.0
    private var cellModels: [PaymentAmountCellViewModel] = []
    private var selectedAmount: TopUpAmount?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Configuration
    
    func setUp(with cellModels: [PaymentAmountCellViewModel], selectedAmount: TopUpAmount?) {
        isHidden = cellModels.isEmpty
        guard !cellModels.isEmpty else { return }
        self.selectedAmount = selectedAmount
        self.cellModels = cellModels
        adjustCollectionViewHeight()
        amountCollectionView.reloadData()
        adjustOtherAmountVisibility()
        updateOtherAmountTextField()
    }
    
    func showInvalidCustomAmountError(_ error: String?) {
        otherAmountTextField.showError(error)
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
        setUpCollectionView()
        setUpAmountTextField()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(mainStackView)
        
        mainStackView.addArrangedSubview(amountContainer)
        mainStackView.addArrangedSubview(otherAmountContainer)
        
        amountContainer.addArrangedSubview(amountHeaderLabel)
        amountContainer.addArrangedSubview(amountCollectionView)
        
        otherAmountContainer.addArrangedSubview(otherAmountHeaderLabel)
        otherAmountContainer.addArrangedSubview(otherAmountTextField)
    }
    
    private func prepareStyles() {
        amountHeaderLabel.text = localized("pl_topup_text_amountSelect")
        otherAmountHeaderLabel.text = localized("pl_topup_text_anothAmonut")
        currencyAccessoryView.setText(CurrencyType.złoty.name)
        amountCollectionView.backgroundColor = .white
        amountCollectionView.clipsToBounds = false
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 24.0
        
        amountContainer.axis = .vertical
        amountContainer.spacing = 8.0
        
        otherAmountContainer.axis = .vertical
        otherAmountContainer.spacing = 8.0
        
        otherAmountTextField.setHeight(48.0)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionViewHeightConstraint,
        ])
    }
    
    private func setUpCollectionView() {
        amountCollectionView.dataSource = self
        amountCollectionView.delegate = self
        amountCollectionView.register(PaymentAmountCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PaymentAmountCollectionViewCell.self))
    }
    
    private func adjustCollectionViewHeight() {
        collectionViewHeightConstraint.constant = getCollectionViewHeight(numberOfItems: cellModels.count)
        layoutIfNeeded()
    }
    
    private func getCollectionViewHeight(numberOfItems: Int) -> CGFloat {
        guard numberOfItems > 0 else {
            return 0.0
        }
        
        let itemHeight = collectionView(self.amountCollectionView,
                                        layout: self.amountCollectionView.collectionViewLayout,
                                        sizeForItemAt: IndexPath(row: 0, section: 0)).height
        let numberOfRows = Int((Double(numberOfItems) / numberOfColumns).rounded(.awayFromZero))
        let totalSpacingHeight = CGFloat(numberOfRows - 1) * cellSpacing
        return CGFloat(numberOfRows) * itemHeight + totalSpacingHeight
    }
    
    private func setUpAmountTextField() {
        otherAmountTextField.textField.setRightAccessory(.view(currencyAccessoryView))
        let amountFormatter = PLAmountTextFieldFormatter(maximumIntegerDigits: 4,
                                                         maximumFractionDigits: 0,
                                                         usesGroupingSeparator: true)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: amountTextFieldCustomization)
        otherAmountTextField.textField.setEditingStyle(.writable(configuration: configuration))
        otherAmountTextField.textField.updatableDelegate = self
    }
    
    private func amountTextFieldCustomization(for component: LisboaTextField.CustomizableComponents) {
        component.textField.autocorrectionType = .no
        component.textField.spellCheckingType = .no
        component.textField.keyboardType = .numberPad
    }
    
    private func adjustOtherAmountVisibility() {
        switch selectedAmount {
        case .custom:
            otherAmountContainer.isHidden = false
        default:
            otherAmountContainer.isHidden = true
        }
    }
    
    private func updateOtherAmountTextField() {
        if case .custom(let amount) = selectedAmount, let amount = amount {
            otherAmountTextField.textField.setText("\(amount)")
        } else {
            otherAmountTextField.textField.setText(nil)
        }
    }
}

extension PaymentAmountSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(type: PaymentAmountCollectionViewCell.self, at: indexPath)
        let cellModel = cellModels[indexPath.row]
        cell.setUp(with: cellModel)
        return cell
    }
}

extension PaymentAmountSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        endEditing(true)
        let cellModel = cellModels[indexPath.row]
        switch cellModel {
        case .custom:
            delegate?.didSelectTopUpAmount(.custom(amount: nil))
        case .fixed(let value, _):
            delegate?.didSelectTopUpAmount(.fixed(value))
        }
    }
}

extension PaymentAmountSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.size.width - (2 * cellSpacing)) / 3.0).rounded(.down)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension PaymentAmountSelectionView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        let amount = Int(otherAmountTextField.textField.text ?? "")
        delegate?.didSelectTopUpAmount(.custom(amount: amount))
    }
}
