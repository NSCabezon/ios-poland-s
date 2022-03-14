import UI
import CoreFoundationLib
import PLUI
import SANLegacyLibrary
import PLCommons

final class ZusSMETransferFormView: UIView {
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let views: [UIView]
    private let transferDateSelector: TransferDateSelector

    init(language: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        transferDateSelector = TransferDateSelector(
            language: language,
            dateFormatter: dateFormatter
        )
        views = [accountSelectorLabel,
                 selectedAccountView,
                 transferDateSelector]
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ZusSMETransferFormView {
    func setUp() {
        addSubviews()
        configureView()
    }
    
    func addSubviews() {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        accountSelectorLabel.text = localized("pl_taxTransfer_label_account")
    }
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            accountSelectorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            accountSelectorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountSelectorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            selectedAccountView.topAnchor.constraint(equalTo: accountSelectorLabel.bottomAnchor, constant: 8),
            selectedAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectedAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            transferDateSelector.topAnchor.constraint(equalTo: selectedAccountView.bottomAnchor, constant: 8),
            transferDateSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transferDateSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transferDateSelector.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}
