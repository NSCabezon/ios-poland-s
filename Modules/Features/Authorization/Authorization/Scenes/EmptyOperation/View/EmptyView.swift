//
//  EmptyView.swift
//  Authorization
//
//  Created by 186484 on 27/04/2022.
//

import PLUI
import CoreFoundationLib

public final class EmptyView: UIView {

    private var imageView: UIImageView = {
        let imageView = UIImageView(image: PLAssets.image(named: "leavesEmpty"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .santander(family: .headline, type: .regular, size: 18)
        label.textColor = .lisboaGray
        label.numberOfLines = 0
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUp(title: String, description: String) {
        let string = "\(localized(title))\n\"\(localized(description))\""
        let attrString = NSMutableAttributedString(string: string)
        
        let range = attrString.mutableString.range(of: localized(title), options: .caseInsensitive)
        attrString.addAttribute(.font, value: UIFont.santander(family: .headline, type: .bold, size: 18),
                                range: range)
        titleLabel.attributedText = attrString
    }
}

private extension EmptyView {
    private func setUp() {
        prepareSubviews()
        prepareLayout()
    }
    
    private func prepareSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    private func prepareLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
}



