import UIKit
import CoreFoundationLib
import UIOneComponents
import PLUI

class PLQuickBalanceSettingsAccountView: UIView {
    let account = PLQuickBalanceSettingsSelectAccountView()

    var viewModelAmount: OneRadioButtonViewModel
    var viewModelPercentage: OneRadioButtonViewModel

    let oneRadioButtonAmount = OneRadioButtonView()
    let oneRadioButtonPercentage = OneRadioButtonView()

    let amountView = OneInputAmountView()
    let oneInputAmountError = OneSubLabelError()
    var constraintsAmount: [NSLayoutConstraint]?
    var constraintsPercentage: [NSLayoutConstraint]?

    let emptylabel = UILabel()
    let button = UIButton()
    let image = UIImageView()

    var selectIndex: Int
    let showRadioButtons: Bool
    init(showRadioButtons: Bool = true) {
        self.showRadioButtons = showRadioButtons
        selectIndex = 0
        viewModelAmount = OneRadioButtonViewModel(status: .inactive,
                                             titleKey: "pl_quickView_label_showAsAmount",
                                             isSelected: false)
        viewModelPercentage = OneRadioButtonViewModel(status: .inactive,
                                             titleKey: "pl_quickView_label_showAsPercentage",
                                             isSelected: false)

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fill(title: String, subtitle: String, amount: Int? = nil) {
        account.title.text = title
        account.subtitle.text = subtitle

        if let amount = amount, amount > 0 {
            selectIndex = 1
            amountView.setAmount(String(amount))
        } else {
            selectIndex = 0
            amountView.setAmount("")
        }

        configureAccountView()
    }

    func fillEmpty() {
        configureEmptyView()
    }

    func removeAllSubviews() {
        image.removeFromSuperview()
        emptylabel.removeFromSuperview()
        button.removeFromSuperview()

        account.removeFromSuperview()
        oneRadioButtonAmount.removeFromSuperview()
        amountView.removeFromSuperview()
        oneRadioButtonPercentage.removeFromSuperview()

    }

    func configureAccountView(){
        removeAllSubviews()
        addSubview(account)
        if showRadioButtons {
            addSubview(oneRadioButtonAmount)
            addSubview(amountView)
            addSubview(oneRadioButtonPercentage)

            oneRadioButtonAmount.delegate = self
            oneRadioButtonAmount.setViewModel(viewModelAmount, index: 0)
            oneRadioButtonPercentage.delegate = self
            oneRadioButtonPercentage.setViewModel(viewModelPercentage, index: 1)

            amountView.setupTextField(OneInputAmountViewModel(status: .activated,
                                                              type: .text))
            oneInputAmountError.setContainer(amountView)
            addSubview(oneInputAmountError)
        }

        account.layer.cornerRadius = 8
        account.layer.borderWidth = 1
        account.layer.borderColor = UIColor(red: 219/255.0,
                                            green: 224/255.0,
                                            blue: 227/255.0,
                                            alpha: 1).cgColor

        account.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            account.leadingAnchor.constraint(equalTo: leadingAnchor),
            account.trailingAnchor.constraint(equalTo: trailingAnchor),
            account.topAnchor.constraint(equalTo: topAnchor)
        ])

        if showRadioButtons {
            oneRadioButtonAmount.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                oneRadioButtonAmount.leadingAnchor.constraint(equalTo: leadingAnchor),
                oneRadioButtonAmount.trailingAnchor.constraint(equalTo: trailingAnchor),
                oneRadioButtonAmount.topAnchor.constraint(equalTo: account.bottomAnchor, constant: 0)
            ])

            oneRadioButtonPercentage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                oneRadioButtonPercentage.leadingAnchor.constraint(equalTo: leadingAnchor),
                oneRadioButtonPercentage.trailingAnchor.constraint(equalTo: trailingAnchor),
                oneRadioButtonPercentage.topAnchor.constraint(equalTo: oneRadioButtonAmount.bottomAnchor)
            ])

            amountView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                amountView.leadingAnchor.constraint(equalTo: leadingAnchor),
                amountView.trailingAnchor.constraint(equalTo: trailingAnchor),
                amountView.topAnchor.constraint(equalTo: oneRadioButtonPercentage.bottomAnchor),
            ])

            constraintsAmount = [oneRadioButtonPercentage.bottomAnchor.constraint(equalTo: bottomAnchor)]
            constraintsPercentage = [oneInputAmountError.bottomAnchor.constraint(equalTo: bottomAnchor)]
        } else {
            NSLayoutConstraint.activate([
                account.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        updateStateRadioButton()
    }

    func updateStateRadioButton() {
        for radioButton in [oneRadioButtonAmount,
                            oneRadioButtonPercentage] {
            radioButton.setByStatus(radioButton.index == selectIndex ? .activated : .inactive)
        }

        if selectIndex == 0 {
            amountView.alpha = 0
            amountView.setAmount("")
            oneInputAmountError.alpha = 0
            if let constraints = constraintsPercentage {
                NSLayoutConstraint.deactivate(constraints)
            }
            if let constraints = constraintsAmount {
                NSLayoutConstraint.activate(constraints)
            }
        } else {
            amountView.alpha = 1
            oneInputAmountError.alpha = 1
            if let constraints = constraintsPercentage {
                NSLayoutConstraint.activate(constraints)
            }
            if let constraints = constraintsAmount {
                NSLayoutConstraint.deactivate(constraints)
            }
        }
    }

    func configureEmptyView(){
        removeAllSubviews()

        addSubview(image)
        addSubview(emptylabel)
        addSubview(button)

        emptylabel.text = localized("pl_quickView_text_secAcc")
        emptylabel.font = UIFont.santander(family: .text, type: .light, size: 16)

        emptylabel.numberOfLines = 0
        emptylabel.textAlignment = .center

        button.setTitle(localized("pl_quickView_button_selectAcc"), for: .normal)
        button.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.Legacy.sanRed, for: .normal)
        button.layer.cornerRadius = 24

        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 0)

        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        image.image = PLAssets.image(named: "leavesEmpty")

        emptylabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptylabel.leadingAnchor.constraint(equalTo: leadingAnchor,  constant: 0),
            emptylabel.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: 0),
            emptylabel.topAnchor.constraint(equalTo: topAnchor, constant: 32)
        ])

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor,  constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: -16),
            button.topAnchor.constraint(equalTo: emptylabel.bottomAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 48),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor,  constant: 0),
            image.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: 0),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

extension PLQuickBalanceSettingsAccountView: OneRadioButtonViewDelegate {
    func didSelectOneRadioButton(_ index: Int) {
        selectIndex = index
        updateStateRadioButton()
    }
}
