
import UI
import Commons

public final class SelectedAccountView: UIView {
    
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let accountNameLabel = UILabel()
    private let accountNumberLabel = UILabel()
    private let availableMoneyLabel = UILabel()
    private let editButton = EditButton()
    private var changeButtonAction: (() -> Void)?
    private var viewModel: SelectableAccountViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setViewModel(_ viewModel: [SelectableAccountViewModel]) {
        var selectedAccount: SelectableAccountViewModel
        if viewModel.count == 1, let onlyViewModel = viewModel.first {
            selectedAccount = onlyViewModel
        } else if let defaultAccount = viewModel.first(where: { $0.isSelected }) {
            selectedAccount = defaultAccount
        } else {
            return
        }
        self.viewModel = selectedAccount
        accountNameLabel.text = selectedAccount.name
        accountNumberLabel.text = selectedAccount.accountNumber
        let availableFoundText = selectedAccount.availableFunds
        availableMoneyLabel.text = availableFoundText
        editButton.isHidden = viewModel.count == 1
    }
    
    public func setChangeAction(_ action: (() -> Void)?) {
        self.changeButtonAction = action
    }
    
}

extension SelectedAccountView {
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(editButton)
        verticalStackView.addArrangedSubview(accountNameLabel)
        verticalStackView.addArrangedSubview(accountNumberLabel)
        verticalStackView.addArrangedSubview(availableMoneyLabel)
    }
    
    func prepareStyles() {
        backgroundColor = .white
        drawRoundedBorderAndShadow(
            with: .init(color: .skyGray, opacity: 1, radius: 1, withOffset: 0, heightOffset: 4),
            cornerRadius: 4,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
        horizontalStackView.alignment = .center
        verticalStackView.spacing = 4
        verticalStackView.axis = .vertical
        accountNameLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                  font: .santander(family: .micro, type: .bold, size: 14)))
        accountNumberLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                   font: .santander(family: .micro,
                                                                    type: .regular,
                                                                    size: 12)))
        availableMoneyLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                    font: .santander(family: .micro,
                                                                     type: .bold,
                                                                     size: 14)))
        editButton.configure(image: PLAssets.image(named: "editIcon"),
                             name: localized(localized("pl_foundtrans_link_changeAccount"))) { [weak self] in
            self?.changeButtonAction?()
        }
        layer.cornerRadius = 4
        layer.borderColor = UIColor.mediumSkyGray.cgColor
        layer.borderWidth = 1
    }
    
    func setUpLayout() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        availableMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
