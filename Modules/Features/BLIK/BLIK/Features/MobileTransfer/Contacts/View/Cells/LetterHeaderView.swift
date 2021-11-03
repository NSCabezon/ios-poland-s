import Foundation

class LetterHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "BLIK.LetterHeaderView"
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .headline, type: .regular, size: 16)
        label.textColor = .lisboaGray
        return label
    }()
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setText(_ text: String) {
        letterLabel.text = text
    }
    
    private func setUp() {
        prepareSubviews()
        prepareLayout()
        contentView.backgroundColor = .white
    }
    
    private func prepareSubviews() {
        addSubview(letterLabel)
    }
    
    private func prepareLayout() {
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            letterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            letterLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            letterLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ])
    }
}
