//
//  TickView.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/12/2021.
//

import UIKit

final class TickView: UIView {
    // MARK: Views
    
    private let imageView = UIImageView()
    
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
        backgroundColor = .darkTorquoise
        addSubview(imageView)
        layer.cornerRadius = 8.0
        clipsToBounds = true
        imageView.image = Images.Form.tickIcon
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
            widthAnchor.constraint(equalToConstant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 8.0)
        ])
    }

}
