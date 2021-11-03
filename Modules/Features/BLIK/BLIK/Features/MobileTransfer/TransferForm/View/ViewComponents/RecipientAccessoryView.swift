import UI
import Commons

extension MobileTransferFormView {
    final class RecipientAccessoryView: UIView {
        private let imageView = UIImageView()
        private let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUp() {
            addSubviews()
            prepareStyles()
            setUpLayout()
        }
        
        private func addSubviews() {
            backgroundColor = .darkTorquoise
            addSubview(label)
            addSubview(imageView)
        }
        
        private func prepareStyles() {
            label.applyStyle(LabelStylist(textColor: .white,
                                          font: Consts.Font.textFont))
            label.text = localized("pl_blik_link_contancs")
            label.textAlignment = .center
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = .white
            imageView.image = Images.MobileTransfer.contacts
        }
        
        private func setUpLayout() {
            label.translatesAutoresizingMaskIntoConstraints = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: Consts.Anchor.image.top),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
                label.leftAnchor.constraint(equalTo: leftAnchor, constant: Consts.Anchor.label.left),
                label.rightAnchor.constraint(equalTo: rightAnchor, constant: Consts.Anchor.label.right),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Consts.Anchor.label.bottom)
            ])
        }
    }
    
    fileprivate struct Consts {
        
        struct Font {
            static let textFont: UIFont = .santander(family: .text, type: .regular, size: 10)
        }
        
        struct Anchor {
            static let label: UIEdgeInsets = .init(top: .zero, left: 5, bottom: -5, right: -5)
            static let image: UIEdgeInsets = .init(top: 10, left: .zero, bottom: .zero, right: .zero)
        }
    }
}

