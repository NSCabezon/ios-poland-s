import SANPLLibrary
import Foundation
import UI
import CoreFoundationLib

class PLQuickBalanceAccountHistoryView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let priceLabel = UILabel()
    let seperator = UIView()
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func setLabelsWith(item: PLQuickBalanceDTOElement) {
        subtitleLabel.text = item.lastTransaction?.title ?? ""
        guard
            let value = item.lastTransaction?.amount
        else {
            priceLabel.text = ""
            return
        }
        let amount = NSDecimalNumber(value: value)
        let amountEntity = AmountEntity(value: amount.decimalValue, currencyCode: item.currencyCode ?? "")
        priceLabel.text = amountEntity.getFormattedAmountUI()
    }
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(priceLabel)
        addSubview(seperator)
        
        titleLabel.text = localized("pl_quickView_label_latestTransaction")
        titleLabel.font = UIFont.santander(family: .headline, type: .bold, size: 14)
        subtitleLabel.font = UIFont.santander(family: .text, type: .regular, size: 14)
        priceLabel.font = UIFont.santander(family: .text, type: .bold, size: 13)
        priceLabel.textAlignment = .right
        seperator.backgroundColor = UIColor(red: 86/255.0,
                                            green: 88/255.0,
                                            blue: 89/255.0,
                                            alpha: 0.1)
        makeConstraints()
    }

    func makeConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        ])

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperator.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            seperator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

