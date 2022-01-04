//
//  PaymentAmountSelectionView.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/12/2021.
//

import UIKit
import UI
import PLUI
import Commons
import PLCommons

final class PaymentAmountSelectionView: UIView {
    // MARK: Views
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: Properties
    
    private let cellReuseIdentifier = "PaymentAmountCollectionViewCell"
    private let cellSpacing: CGFloat = 16.0
    private var selectedItemIndex: Int?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Configuration
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
        setUpCollectionView()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(collectionView)
    }
    
    private func prepareStyles() {
        backgroundColor = .blue
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
    }
    
    private func setUpLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaymentAmountCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PaymentAmountCollectionViewCell.self))
    }
}

extension PaymentAmountSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        #warning("todo: remove mock cells")
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(type: PaymentAmountCollectionViewCell.self, at: indexPath)
        let cellStyle: PaymentAmountCollectionViewCell.Style = selectedItemIndex == indexPath.row ? .selected : .unselected
        cell.setStyle(cellStyle)
        return cell
    }
}

extension PaymentAmountSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = indexPath.row
        selectedItemIndex = selectedItemIndex == itemIndex ? nil : itemIndex
        collectionView.reloadData()
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
