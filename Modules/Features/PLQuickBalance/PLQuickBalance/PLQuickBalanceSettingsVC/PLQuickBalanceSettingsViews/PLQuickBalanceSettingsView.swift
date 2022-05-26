import UIKit
import CoreFoundationLib
import SANPLLibrary

class PLQuickBalanceSettingsView: UIView {
    let scrollView = UIScrollView()
    let contentScroll = UIView()
    let logo = UIImageView()
    let titleLabel = UILabel()
    let switchView = UISwitch()
    let infoView = PLQuickBalanceSettingsInfoView()

    let example = PLQuickBalanceSettingsViewExample()
    let button = UIButton()

    let accountLabelFirst = UILabel()
    let accountFirst = PLQuickBalanceSettingsAccountView()
    let accountLabelSecond = UILabel()
    let accountSecond = PLQuickBalanceSettingsAccountView(showRadioButtons: false)
    var constraintHideKeyboard: [NSLayoutConstraint]?
    var constraintShowKeyboard: [NSLayoutConstraint]?

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(isOn: Bool, secondAccountAvaiable: Bool) {
        infoView.removeFromSuperview()
        example.removeFromSuperview()
        accountLabelFirst.removeFromSuperview()
        accountFirst.removeFromSuperview()
        accountLabelSecond.removeFromSuperview()
        accountSecond.removeFromSuperview()

        logo.image = UIImage(named: "logo", in: .module, compatibleWith: nil)
        titleLabel.text = localized("pl_quickView_switcher")
        titleLabel.font = UIFont.santander(family: .text, type: .bold, size: 18)

        contentScroll.addSubview(logo)
        contentScroll.addSubview(titleLabel)
        contentScroll.addSubview(switchView)
        contentScroll.addSubview(infoView)

        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            logo.topAnchor.constraint(equalTo: contentScroll.topAnchor, constant: 16),
            logo.heightAnchor.constraint(equalToConstant: 24),
            logo.widthAnchor.constraint(equalToConstant: 24)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 0)
        ])

        switchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switchView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            switchView.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 0),
            switchView.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -16)
        ])

        switchView.isOn = isOn
        if isOn {
            configureViewsIsOn(secondAccountAvaiable: secondAccountAvaiable)
        } else {
            configureViewsIsOff()
        }
    }

    func configureViewsIsOn(secondAccountAvaiable: Bool) {
        accountLabelFirst.text = localized("pl_quickView_title_firstAcc")
        accountLabelFirst.font = UIFont.santander(family: .text, type: .bold, size: 18)
        accountLabelFirst.numberOfLines = 0
        if secondAccountAvaiable {
            accountLabelSecond.text = localized("pl_quickView_title_secAcc")
            accountLabelSecond.font = UIFont.santander(family: .text, type: .bold, size: 18)
            accountLabelSecond.numberOfLines = 0
        }

        contentScroll.addSubview(accountLabelFirst)
        contentScroll.addSubview(accountFirst)
        contentScroll.addSubview(accountLabelSecond)
        contentScroll.addSubview(accountSecond)

        contentScroll.addSubview(infoView)

        accountLabelFirst.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountLabelFirst.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            accountLabelFirst.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
            accountLabelFirst.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])

        accountFirst.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountFirst.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            accountFirst.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
            accountFirst.topAnchor.constraint(equalTo: accountLabelFirst.bottomAnchor, constant: 16)
        ])
        
        if secondAccountAvaiable {
            accountLabelSecond.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                accountLabelSecond.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
                accountLabelSecond.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
                accountLabelSecond.topAnchor.constraint(equalTo: accountFirst.bottomAnchor, constant: 16)
            ])

            accountSecond.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                accountSecond.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
                accountSecond.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
                accountSecond.topAnchor.constraint(equalTo: accountLabelSecond.bottomAnchor, constant: 16)
            ])
            NSLayoutConstraint.activate([
                infoView.topAnchor.constraint(equalTo: accountSecond.bottomAnchor, constant: 40),
            ])
        } else {
            NSLayoutConstraint.activate([
                infoView.topAnchor.constraint(equalTo: accountFirst.bottomAnchor, constant: 40),
            ])
        }

        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            infoView.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
            infoView.bottomAnchor.constraint(equalTo: contentScroll.bottomAnchor, constant: 0)
        ])
    }

    func configureViewsIsOff() {
        contentScroll.addSubview(example)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            infoView.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
            infoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40)
        ])

        example.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            example.leadingAnchor.constraint(equalTo: contentScroll.leadingAnchor, constant: 24),
            example.trailingAnchor.constraint(equalTo: contentScroll.trailingAnchor, constant: -24),
            example.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 24),
            example.bottomAnchor.constraint(equalTo: contentScroll.bottomAnchor, constant: 0)
        ])
    }

    private func configureView() {
        backgroundColor = .white
        button.setTitle(localized("pl_quickView_button_confirm"), for: .normal)
        button.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14)
        button.backgroundColor = .santanderRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24

        scrollView.addSubview(contentScroll)
        addSubview(scrollView)
        addSubview(button)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])

        contentScroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentScroll.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentScroll.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentScroll.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentScroll.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentScroll.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            button.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 24),
            button.heightAnchor.constraint(equalToConstant: 48)

        ])

        constraintHideKeyboard = [
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ]

        if let constraint = constraintHideKeyboard {
            NSLayoutConstraint.activate(constraint)
        }
    }

    @objc func handleTap(){
        endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if let constraint = constraintHideKeyboard {
            NSLayoutConstraint.deactivate(constraint)
        }

        if let constraint = constraintShowKeyboard {
            NSLayoutConstraint.activate(constraint)
        } else {
            constraintShowKeyboard = [
                button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -keyboardFrame.height),
            ]

            if let constraint = constraintShowKeyboard {
                NSLayoutConstraint.activate(constraint)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){
        if let constraintShowKeyboard = self.constraintShowKeyboard {
            NSLayoutConstraint.deactivate(constraintShowKeyboard)
        }
        if let constraint = self.constraintHideKeyboard {
            NSLayoutConstraint.activate(constraint)
        }

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}


extension PLQuickBalanceSettingsView {
    func configure(with viewModel: PLQuickBalanceSettingsViewModel) {
        let secondAccountAvaiable: Bool = viewModel.allAccounts?.count ?? 0 > 1
        configure(isOn: viewModel.isOn,
                  secondAccountAvaiable: secondAccountAvaiable)

        if let account = viewModel.selectedMainAccount {
            accountFirst.fill(title: account.name,
                              subtitle: account.number,
                              amount: viewModel.amount)
        } else {
            accountFirst.fillEmpty()
        }

        if let account = viewModel.selectedSecondAccount {
            accountSecond.fill(title: account.name,
                               subtitle: account.number)
        } else {
            accountSecond.fillEmpty()
        }
    }
}

