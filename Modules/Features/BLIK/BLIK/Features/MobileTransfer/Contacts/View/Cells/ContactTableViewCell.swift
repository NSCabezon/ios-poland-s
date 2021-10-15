import Foundation
import UI
import PLUI

final class ContactTableViewCell: UITableViewCell {
    static let identifier: String = "BLIK.ContactTableViewCell"
    
    private let container = UIView()
    private let blikImageView = UIImageView(image: PLAssets.image(named: "blikIcon"))
    private let initialsView = UIView()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .micro, type: .bold, size: 16)
        label.textColor = .lisboaGray
        return label
    }()

    private let phoneNoLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .micro, type: .regular, size: 14)
        label.textColor = .lisboaGray
        return label
    }()

    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .headline, type: .bold, size: 16)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        container.backgroundColor = isHighlighted ? .skyGray : .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setHighlighted(selected, animated: animated)
        container.backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setContact(_ contact: Contact, backgroundColor: UIColor) {
        let fullName = contact.fullName
        fullNameLabel.text = fullName.isEmpty ? contact.phoneNumber : fullName
        phoneNoLabel.text = contact.phoneNumber
        initialsView.backgroundColor = backgroundColor
        let separatedFullName = fullName.components(separatedBy: " ")
        let initials = fullName.isEmpty
            ? "#"
            : "\(separatedFullName.first?.prefix(1) ?? "")\(separatedFullName.last?.prefix(1) ?? "")".uppercased()
        initialsLabel.text = initials
    }
    
    private func setUp() {
        prepareSubviews()
        prepareStyles()
        prepareLayout()
    }
    
    private func prepareSubviews() {
        contentView.addSubview(container)
        container.addSubview(blikImageView)
        container.addSubview(fullNameLabel)
        container.addSubview(phoneNoLabel)
        container.addSubview(initialsView)
        initialsView.addSubview(initialsLabel)
    }
    
    private func prepareStyles() {
        selectionStyle = .none
        initialsView.layer.cornerRadius = 20
        initialsView.layer.masksToBounds = true
        container.backgroundColor = .white
        container.drawBorder(cornerRadius: 4, color: .mediumSkyGray, width: 1)
    }
    
    private func prepareLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        blikImageView.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNoLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsView.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fullNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            
            initialsView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            initialsView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            initialsView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            initialsView.widthAnchor.constraint(equalToConstant: 40),
            initialsView.heightAnchor.constraint(equalToConstant: 40),
            
            initialsLabel.centerXAnchor.constraint(equalTo: initialsView.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: initialsView.centerYAnchor),
            
            blikImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            blikImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            blikImageView.widthAnchor.constraint(equalToConstant: 45),
            blikImageView.heightAnchor.constraint(equalToConstant: 45),

            fullNameLabel.topAnchor.constraint(equalTo: initialsView.topAnchor, constant: -3),
            fullNameLabel.leadingAnchor.constraint(equalTo: initialsView.trailingAnchor, constant: 10),
            fullNameLabel.trailingAnchor.constraint(equalTo: blikImageView.leadingAnchor, constant: -4),
            
            phoneNoLabel.leadingAnchor.constraint(equalTo: initialsView.trailingAnchor, constant: 10),
            phoneNoLabel.trailingAnchor.constraint(equalTo: blikImageView.leadingAnchor, constant: -4),
            phoneNoLabel.bottomAnchor.constraint(equalTo: initialsView.bottomAnchor, constant: 3)
        ])
    }
}

