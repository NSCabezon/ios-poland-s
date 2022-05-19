//
//  NoOperationToConfirmView.swift
//  Authorization
//
//  Created by 186484 on 15/04/2022.
//

import UI
import PLUI
import CoreFoundationLib

class NoOperationToConfirmView: UIView {

    //MARK: - Views
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    private lazy var cancelButton: UIButton = {
        let button = LisboaButton()
        button.configureAsWhiteButton()
        let configuration = ShadowConfiguration(color: UIColor.lightSanGray,
                                                opacity: 0.7,
                                                radius: 3.0,
                                                withOffset: 0.0,
                                                heightOffset: 2.0)
        
        button.drawRoundedBorderAndShadow(with: configuration,
                                          cornerRadius: 6.0,
                                          borderColor: UIColor.mediumSkyGray,
                                          borderWith: 1.0)
        button.setTitle(localized("pl_blik_button_refresh"), for: .normal)
        button.labelButtonLines(numberOfLines: 1)
        button.setTextAligment(.center, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction { [weak self] in
            self?.onRefreshTapped?()
        }
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = RedLisboaButton()
        button.setTitle(localized("generic_button_understand"), for: .normal)
        button.setTextAligment(.center, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction { [weak self] in
            self?.onCloseTapped?()
        }
        return button
    }()
            
    var onRefreshTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setupLabels(title: String, description: String) {
        emptyView.setUp(title: title, description: description)
    }
}

private extension NoOperationToConfirmView {
    func setup() {
        addSubviews()
        prepareLayout()
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(emptyView)
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    func prepareLayout() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            emptyView.leftAnchor.constraint(equalTo: leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: rightAnchor),
            
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            buttonsStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor)
        ])
    }
}
