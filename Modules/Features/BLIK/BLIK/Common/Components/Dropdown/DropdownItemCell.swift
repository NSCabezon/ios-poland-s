//
//  DropdownItemCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 25/06/2021.
//

final class DropdownItemCell: UITableViewCell {
    static let identifier = "BLIK.DropdownItemCell"
    private let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ itemTitle: String) {
        title.text = itemTitle
    }
    
    private func setUp() {
        configureSubviews()
        applyStyling()
    }
    
    private func configureSubviews() {
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    private func applyStyling() {
        title.numberOfLines = 1
        title.textColor = .lisboaGray
        title.font = .santander(
            family: .micro,
            type: .regular,
            size: 16
        )
    }
}
