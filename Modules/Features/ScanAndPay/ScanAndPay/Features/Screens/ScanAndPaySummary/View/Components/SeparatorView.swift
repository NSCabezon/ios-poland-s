//
//  SeparatorView.swift
//  ScanAndPay
//
//  Created by 188216 on 11/04/2022.
//

import UIKit

final class SeparatorView: UIView {
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
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1).isActive = true
        backgroundColor = .mediumSkyGray
    }

}
