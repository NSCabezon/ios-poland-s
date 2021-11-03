//
//  CheuqeValidityPeriodSelectorView.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/07/2021.
//

import UIKit
import UI
import Commons
import PLCommons

final class ChequeValidityPeriodSelectorView: UIView {
    private let dropdownView: DropdownView<ChequeValidityPeriod> = DropdownView<ChequeValidityPeriod>(frame: .zero)
    private var onSelected: ((ChequeValidityPeriod) -> Void)?
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.setIdentifiers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configureWithPeriods(
        _ validityPeriods: [ChequeValidityPeriod],
        onSelected: @escaping (ChequeValidityPeriod) -> Void
    ) {
        let dropdownConfiguration = DropdownConfiguration<ChequeValidityPeriod>(
            title: localized("pl_blik_label_chequeTerm"),
            elements: validityPeriods,
            displayMode: .growToScreenBounds(inset: 20)
        )
        dropdownView.configure(dropdownConfiguration)
        self.onSelected = onSelected
    }
    
    public func selectElement(_ element: ChequeValidityPeriod) {
        dropdownView.selectElement(element)
    }
}

private extension ChequeValidityPeriodSelectorView {
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
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityCheques.ChequeValidityPeriodSelectorView.root.id
        dropdownView.accessibilityIdentifier = AccessibilityCheques.ChequeValidityPeriodSelectorView.dropdownView.id
    }
}

extension ChequeValidityPeriodSelectorView: DropdownDelegate {
    func didSelectOption(element: DropdownElement) {
        guard let validityPeriod = element as? ChequeValidityPeriod else { return }
        onSelected?(validityPeriod)
    }
}

