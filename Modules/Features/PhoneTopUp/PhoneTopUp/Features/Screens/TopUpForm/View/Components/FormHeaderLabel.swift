//
//  FormHeaderLabel.swift
//  PhoneTopUp
//
//  Created by 188216 on 07/12/2021.
//

import UIKit

final class FormHeaderLabel: UILabel {
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: Configuration

    private func setUp() {
        font = .santander(family: .micro, type: .regular, size: 14.0)
        textColor = .lisboaGray
    }
}
