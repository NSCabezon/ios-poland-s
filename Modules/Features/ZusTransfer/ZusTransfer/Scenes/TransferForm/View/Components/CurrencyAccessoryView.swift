import UI

extension ZusTransferFormView {
    final class CurrencyAccessoryView: UIView {
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
            backgroundColor = Consts.Color.clear
            addSubview(label)
        }
        
        private func prepareStyles() {
            label.applyStyle(LabelStylist(textColor: Consts.Color.textColor,
                                          font: Consts.Font.textFont))
        }
        
        private func setUpLayout() {
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
        
        func setText(_ text: String) {
            label.text = text
        }
    }
    
    fileprivate struct Consts {
        struct Color {
            static let clear: UIColor = .clear
            static let textColor: UIColor = .brownishGray
        }
        
        struct Font {
            static let textFont: UIFont = .santander(family: .text, type: .regular, size: 14)
        }
    }
}
