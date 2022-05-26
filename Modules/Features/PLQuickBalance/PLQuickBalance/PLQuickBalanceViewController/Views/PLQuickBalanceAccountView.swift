import SANPLLibrary
import Foundation
import UI
import CoreFoundationLib

class PLQuickBalanceAccountView: UIView {
    let titleLabel = UILabel()
    let balanceLabel = UILabel()
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
        titleLabel.text = item.accountDescription ?? ""
        if let type = item.type, let value = item.value {
            switch type {
            case "EXACT_AMOUNT":
                let amount = NSDecimalNumber(value: value)
                let amountEntity = AmountEntity(value: amount.decimalValue, currencyCode: item.currencyCode ?? "")
                balanceLabel.text = amountEntity.getFormattedAmountUI()

            case "PERCENTAGE":
                balanceLabel.text = String(value) + " %"
            default:
                balanceLabel.text = ""
            }
        } else {
            balanceLabel.text = ""
        }
    }
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(balanceLabel)
        addSubview(seperator)

        titleLabel.font = UIFont.santander(family: .text, type: .regular, size: 26)
        balanceLabel.font = UIFont.santander(family: .text, type: .bold, size: 26)
        seperator.backgroundColor = UIColor(red: 86/255.0,
                                            green: 88/255.0,
                                            blue: 89/255.0,
                                            alpha: 0.1)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            balanceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            balanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1)
        ])

        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            seperator.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 11),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
