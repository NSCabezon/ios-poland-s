import UI
import CoreFoundationLib
import PLUI
import SANLegacyLibrary
import PLCommons

protocol ZusSmeTransferFormViewDelegate: AnyObject {
    func changeAccountTapped()
}

final class ZusSmeTransferFormView: UIView {
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let views: [UIView]
    private var selectedDate = Date()
    private let transferDateSelector: TransferDateSelector
    weak var delegate: ZusSmeTransferFormViewDelegate?

    init(language: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        transferDateSelector = TransferDateSelector(
            language: language,
            dateFormatter: dateFormatter
        )
        views = [
            accountSelectorLabel,
            selectedAccountView,
            transferDateSelector
        ]
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with accountViewModel: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountViewModel)
    }
}

private extension ZusSmeTransferFormView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        accountSelectorLabel.text = localized("pl_taxTransfer_label_account")
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.changeAccountTapped()
        }
        transferDateSelector.delegate = self
    }
    
    func setUpLayout() {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
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
    
    func createTextFieldContainer(with headerView: UIView, textFieldView: UIView) -> UIView {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(textFieldView)
        return stackView
    }
    
    func showError(
        for view: LisboaTextFieldWithErrorView,
        with message: String?
    ) {
        if let message = message {
            view.showError(message)
            return
        }
        view.hideError()
    }
}

extension ZusSmeTransferFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        //TODO: next implementation
    }
}

extension ZusSmeTransferFormView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        selectedDate = date
    }
}
