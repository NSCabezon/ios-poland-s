
import PLUI
import UI
import CoreFoundationLib

final class VatAccountDetailsView: UIView {
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private var vatAccountDetails: VATAccountDetails?
    private let formatter: NumberFormatter
    
    init() {
        formatter = .PLAmountNumberFormatterWithoutCurrency
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVatAccountDetails(vatAccountDetails: VATAccountDetails) {
        self.vatAccountDetails = vatAccountDetails
        fillLabel()
    }
}

private extension VatAccountDetailsView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(detailsLabel)
    }
    func configureView() {
        titleLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                           font: .santander(family: .micro,
                                                            type: .regular,
                                                            size: 14),
                                           textAlignment: .left))
        detailsLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                             font: .santander(family: .micro,
                                                              type: .bold,
                                                              size: 14),
                                             textAlignment: .left))
        titleLabel.numberOfLines = 0
        detailsLabel.numberOfLines = 0
        titleLabel.text = localized("pl_zusTransfer_text_linkedAcc")
    }
    
    func fillLabel() {
        guard let vatAccountDetails = vatAccountDetails else { return }
        let shortedAccountNumber = "*" + (vatAccountDetails.number.substring(ofLast: 4) ?? "")
        let formattedAmount = formatter.string(for: vatAccountDetails.availableFunds) ?? ""
        let accoutDetailsText = "\(vatAccountDetails.name) \(shortedAccountNumber) (\(formattedAmount) \(vatAccountDetails.currency))"
        detailsLabel.text = accoutDetailsText
    }
    
    func setUpLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
