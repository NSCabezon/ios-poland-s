import UIKit
import PLUI
import SANPLLibrary
import CoreFoundationLib
import UIOneComponents

protocol PLQuickBalanceSettingsViewControllerProtocol: AnyObject, LoaderPresentable {
    func updateView(_ viewModel: PLQuickBalanceSettingsViewModel)
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?)
    func showMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?)
}

class PLQuickBalanceSettingsVC: UIViewController {

    private var presenter: PLQuickBalanceSettingsPresenterProtocol
    private let settingsView = PLQuickBalanceSettingsView()
    let dependenciesResolver: DependenciesResolver

    init(presenter: PLQuickBalanceSettingsPresenterProtocol, dependenciesResolver: DependenciesResolver) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
        self.view.backgroundColor = .white
        self.title = localized("pl_quickView_toolbar")

        presenter.viewDidLoad()
        settingsView.switchView.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)
        settingsView.button.addTarget(self, action: #selector(onTapSubmit), for: .touchUpInside)

        settingsView.accountFirst.account.button.addTarget(self, action: #selector(onTapAccountFirst), for: .touchUpInside)
        settingsView.accountSecond.account.button.addTarget(self, action: #selector(onTapAccountSecond), for: .touchUpInside)
        settingsView.accountFirst.button.addTarget(self, action: #selector(onTapAccountFirst), for: .touchUpInside)
        settingsView.accountSecond.button.addTarget(self, action: #selector(onTapAccountSecond), for: .touchUpInside)
        settingsView.accountFirst.amountView.delegate = self
    }
}

extension PLQuickBalanceSettingsVC: PLQuickBalanceSettingsViewControllerProtocol {
    func updateView(_ viewModel: PLQuickBalanceSettingsViewModel) {
        settingsView.configure(with: viewModel)
    }
}

extension PLQuickBalanceSettingsVC: OneInputAmountViewDelegate {
    func textFieldDidChange() {
        let amount = Int(settingsView.accountFirst.amountView.getAmount().replacingOccurrences(of: " ", with: ""))
        if amount ?? 0 > 0 {
            settingsView.accountFirst.amountView.hideError()
            settingsView.accountFirst.oneInputAmountError.hideError()
        } else {
            settingsView.accountFirst.amountView.showError(localized("pl_quickView_errorText_amountTooLow"))
            settingsView.accountFirst.oneInputAmountError.showError(localized("pl_quickView_errorText_amountTooLow"))
        }
        presenter.updateAmount(amount: amount)
    }

    func textFielEndEditing() {
        let amount = Int(settingsView.accountFirst.amountView.getAmount())
        presenter.updateAmount(amount: amount)
    }
}

extension PLQuickBalanceSettingsVC {

    @objc private func onTapSwitch() {
        presenter.onTapSwitch()
    }

    @objc private func onTapSubmit() {
        if settingsView.accountFirst.selectIndex == 1 {
            if let amount = Int(settingsView.accountFirst.amountView.getAmount().replacingOccurrences(of: " ", with: "")),
               amount > 0 {
                presenter.onTapSubmit()
            } else {
                settingsView.accountFirst.amountView.showError(localized("pl_quickView_errorText_amountTooLow"))
                settingsView.accountFirst.oneInputAmountError.showError(localized("pl_quickView_errorText_amountTooLow"))
            }
        } else {
            presenter.onTapSubmit()
        }
    }

    @objc private func onTapAccountFirst() {
        presenter.changeMainAccount()
    }

    @objc private func onTapAccountSecond() {
        presenter.changeSecondAccount()
    }
}

extension PLQuickBalanceSettingsVC: ErrorPresentable {}
