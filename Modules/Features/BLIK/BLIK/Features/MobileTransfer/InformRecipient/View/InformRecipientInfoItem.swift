import UI

class InformRecipientInfoItem: UIView {
    
    struct ViewModel {
        let header: String
        let value: NSAttributedString
        var icon: UIImage? = nil
        var hideSeparator: Bool = false
    }

    private let header = UILabel()
    private let value = UILabel()
    private let separator = SeparatorView()
    private let icon = UIImageView()

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InformRecipientInfoItem {
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareData()
        prepareLayout()
    }
    
    func addSubviews() {
        [header, value, icon, separator]
            .forEach { addSubview($0) }
    }
    
    func prepareStyles() {
        header.font = .santander(family: .micro, type: .regular, size: 14)
        header.numberOfLines = 0
        header.textColor = .brownishGray
        
        value.font = .santander(family: .micro, type: .bold, size: 16)
        value.numberOfLines = 0
        value.textColor = .brownishGray
        
        icon.contentMode = .scaleAspectFit
    }
    
    func prepareData() {
        self.header.text = viewModel.header
        
        self.value.attributedText = viewModel.value
        self.icon.image = viewModel.icon
        self.separator.isHidden = viewModel.hideSeparator
    }

    func prepareLayout() {
        [header, value, icon, separator]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        value.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            value.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
            value.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            icon.leadingAnchor.constraint(equalTo: value.trailingAnchor, constant: 8),
            icon.centerYAnchor.constraint(equalTo: value.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 19),
            icon.widthAnchor.constraint(equalToConstant: 19),

            separator.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 17),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

