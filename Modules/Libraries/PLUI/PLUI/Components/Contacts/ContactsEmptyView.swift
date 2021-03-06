import Foundation
import UI
import CoreFoundationLib

public final class ContactsEmptyView: UIView {
    public enum `Type` {
        case emptyContacts(textKey: String)
        case noSearchResult(query: String, textKey: String)
    }

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
    
    public func setUp(with type: Type) {
        switch type {
        case .emptyContacts(let textKey):
            titleLabel.configureText(withKey: textKey)
        case .noSearchResult(let query, let textKey):
            let string = "\(localized(textKey))\n\n\"\(query)\""
            let attrString = NSMutableAttributedString(string: string)

            let range = attrString.mutableString.range(of: query, options: .caseInsensitive)
            attrString.addAttribute(.font, value: UIFont.santander(family: .headline, type: .bold, size: 18),
                                    range: range)
            titleLabel.attributedText = attrString
        }
    }
}

private extension ContactsEmptyView {
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
