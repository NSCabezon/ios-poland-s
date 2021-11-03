//
//  AliasDatePeriodSelectorView.swift
//  BLIK
//
//  Created by 186491 on 22/09/2021.
//

import UIKit
import UI
import Commons

final class AliasDatePeriodSelectorView: UIView {
    private let dropdownView: DropdownView<AliasDateValidityPeriod> = DropdownView<AliasDateValidityPeriod>(frame: .zero)
    private var onSelected: ((AliasDateValidityPeriod) -> Void)?
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configureWithPeriods(
        _ validityPeriods: [AliasDateValidityPeriod],
        onSelected: @escaping (AliasDateValidityPeriod) -> Void
    ) {
        let dropdownConfiguration = DropdownConfiguration<AliasDateValidityPeriod>(
            title: localized("pl_blik_label_chequeTerm"),
            elements: validityPeriods,
            displayMode: .growToScreenBounds(inset: 20)
        )
        dropdownView.configure(dropdownConfiguration)
        self.onSelected = onSelected
    }
    
    public func selectElement(_ element: AliasDateValidityPeriod) {
        dropdownView.selectElement(element)
    }
}

private extension AliasDatePeriodSelectorView {
    func setUp() {
        addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.addArrangedSubview(horizontalLine(color: .mediumSkyGray))
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(horizontalLine(color: .mediumSkyGray))
        verticalStackView.axis = .vertical
        verticalStackView.addArrangedSubview(verticalLine(color: .mediumSkyGray))
        verticalStackView.addArrangedSubview(dropdownView)
        verticalStackView.addArrangedSubview(verticalLine(color: .darkTurqLight))
        dropdownView.delegate = self
        horizontalStackView.fullFit(topMargin: 0, bottomMargin: 0, leftMargin: 0, rightMargin: 0)
    }
    
    func verticalLine(color: UIColor) -> UIView {
        let lineContainer = UIView()
        lineContainer.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineContainer.backgroundColor = color
        return lineContainer
    }
    
    func horizontalLine(color: UIColor) -> UIView {
        let line = UIView()
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = color
        return line
    }
}

extension AliasDatePeriodSelectorView: DropdownDelegate {
    func didSelectOption(element: DropdownElement) {
        guard let validityPeriod = element as? AliasDateValidityPeriod else { return }
        onSelected?(validityPeriod)
    }
}

