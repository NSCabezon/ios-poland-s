//
//  ItemSelectorSectionHeader.swift
//  PLScenes
//
//  Created by 185167 on 09/02/2022.
//

final class ItemSelectorSectionHeader: UIView {
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(with headerText: String) {
        headerLabel.text = headerText
    }
    
    private func setUp() {
        configureLayout()
        configureStyling()
    }
    
    private func configureLayout() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func configureStyling() {
        backgroundColor = .white
        headerLabel.font = .santander(family: .text, type: .regular, size: 16)
        headerLabel.textColor = .greyishBrown
    }
}
