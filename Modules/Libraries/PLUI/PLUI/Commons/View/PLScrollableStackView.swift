//
//  CreditCardRepaymentDetailsViewScrollableStackView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 08/06/2021.
//

import UIKit

public final class PLScrollableStackView: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    public override var intrinsicContentSize: CGSize {
        return stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Public
    
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        stackView.insertArrangedSubview(view, at: stackIndex)
    }
    
    public var spacing: CGFloat {
        set { stackView.spacing = newValue }
        get { stackView.spacing }
    }
    
    public var distribution: UIStackView.Distribution {
        set { stackView.distribution = newValue }
        get { stackView.distribution }
    }

    public var alignment: UIStackView.Alignment {
        set { stackView.alignment = newValue }
        get { stackView.alignment }
    }
    
    public var contentInset: UIEdgeInsets {
        set { scrollView.contentInset = newValue }
        get { scrollView.contentInset }
    }
    
    // MARK - Private
    
    private func setup() {
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupSubviews() {
        setupScrollView()
        setupStackView()
    }
    
    private func setupLayouts() {
        setupScrollViewConstraint()
        setupStackViewConstraint()
    }
    
    private func setupScrollView() {
        scrollView.clipsToBounds = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    private func setupScrollViewConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupStackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

