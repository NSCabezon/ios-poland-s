//
//  ScanAndPaySummaryView.swift
//  ScanAndPay
//
//  Created by 188216 on 11/04/2022.
//

import UIKit

final class SummaryView: UIView {
    // MARK: Properties
    
    private let mainScrollView = UIScrollView()
    private let contentView = UIView()
    private let mainStackView = UIStackView()
    private let codeContainerView = UIView()
    private let codeImageView = UIImageView()
    private let fieldsContainerView = UIView()
    private let fieldsStackView = UIStackView()
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: Configuration
    
    func configure(with viewModel: SummaryViewModel) {
        codeImageView.image = viewModel.qrCodeImage
        addFields(with: viewModel.fields)
    }
    
    func getSnapshot() -> UIImage {
        return contentView.asImage()
    }
}

private extension SummaryView {
    func setUp() {
        addSubviews()
        setUpLayout()
        prepareStyles()
    }
    
    func addSubviews() {
        addSubviewConstraintToEdges(mainScrollView)
        mainScrollView.addSubviewConstraintToEdges(contentView)
        contentView.addSubviewConstraintToEdges(mainStackView)
        
        mainStackView.addArrangedSubview(codeContainerView)
        mainStackView.addArrangedSubview(fieldsContainerView)
        mainStackView.addArrangedSubview(UIView())
        
        codeContainerView.addSubview(codeImageView)
        
        fieldsContainerView.addSubviewConstraintToEdges(fieldsStackView)
    }
    
    func setUpLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 34
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24.0, leading: 16, bottom: 16, trailing: 16)
        
        fieldsStackView.axis = .vertical
        fieldsStackView.spacing = 16
        fieldsStackView.isLayoutMarginsRelativeArrangement = true
        fieldsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24.0, leading: 24, bottom: 24, trailing: 24)
        fieldsContainerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        codeImageView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeImageView.heightAnchor.constraint(equalTo: codeImageView.widthAnchor),
            codeImageView.widthAnchor.constraint(equalTo: codeContainerView.widthAnchor, multiplier: 0.5),
            codeImageView.centerXAnchor.constraint(equalTo: codeContainerView.centerXAnchor),
            codeImageView.topAnchor.constraint(equalTo: codeContainerView.topAnchor),
            codeImageView.bottomAnchor.constraint(equalTo: codeContainerView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
        ])
    }
    
    func prepareStyles() {
        backgroundColor = .white
        fieldsContainerView.drawBorder(color: .mediumSkyGray)
    }
    
    func addFields(with viewModels: [SummaryFieldViewModel]) {
        let fieldViews: [UIView] = viewModels.map {
            let fieldView = SummaryFieldView()
            fieldView.configure(with: $0)
            return fieldView
        }
        
        for fieldView in fieldViews {
            fieldsStackView.addArrangedSubview(fieldView)
        }
    }
}
