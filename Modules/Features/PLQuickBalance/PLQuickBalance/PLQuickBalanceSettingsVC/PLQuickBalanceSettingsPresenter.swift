import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol PLQuickBalanceSettingsPresenterProtocol {
    var view: PLQuickBalanceSettingsViewControllerProtocol? { get set }
    func viewDidLoad()
    func onTapSubmit()
    func onTapSwitch()
    func changeMainAccount()
    func changeSecondAccount()
    func updateAmount(amount: Double?)
}

final class PLQuickBalanceSettingsPresenter {
    let dependenciesResolver: DependenciesResolver

    weak var view: PLQuickBalanceSettingsViewControllerProtocol?
    
    var viewModel: PLQuickBalanceSettingsViewModel = PLQuickBalanceSettingsViewModel(isOn: false,
                                                                                     allAccounts: nil,
                                                                                     selectedAccount: nil,
                                                                                     selectedSecondAccount: nil,
                                                                                     amount: 0)

    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }

    private let managersProvider: PLManagersProviderProtocol

    private var getLastTransactionUseCase: GetLastTransactionProtocol {
        dependenciesResolver.resolve()
    }

    private var quickBalanceSettingsUseCase: PLQuickBalancePostSettingsUseCaseProtocol {
        dependenciesResolver.resolve()
    }

    private var quickBalanceGetSettingsUseCase: PLQuickBalanceGetSettingsUseCaseProtocol {
        dependenciesResolver.resolve()
    }

    private var coordinator: PLQuickBalanceCoordinatorProtocol {
        dependenciesResolver.resolve(for: PLQuickBalanceCoordinatorProtocol.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }

    func updateView() {
        view?.updateView(viewModel)
    }
}

extension PLQuickBalanceSettingsPresenter: PLQuickBalanceSettingsPresenterProtocol {
    func viewDidLoad() {
        getDataSettings()
    }

    func getDataSettings() {
        view?.showLoader()
        Scenario(useCase: quickBalanceGetSettingsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.getDataAccounts(settings: output.dto)
            }
            .onError { [weak self] error in
                self?.view?.hideLoader() { }
            }
    }

    func getDataAccounts(settings: [PLGetQuickBalanceSettingsDTO]) {
        let accounts = try? self.managersProvider.getGlobalPositionManager().getAllProducts().get().accounts
        self.view?.hideLoader(completion: { [weak self] in
            self?.viewModel.allAccounts = accounts?.compactMap({ accountDTO in
                PLQuickBalanceSettingsViewModel.map(accountDTO)
            })

            if let id = settings[safe: 0]?.accountNo {
                self?.viewModel.selectedMainAccount = PLQuickBalanceSettingsViewModel.map(accounts?.first(where: {$0.number == id }))
            }

            if let id = settings[safe: 1]?.accountNo {
                self?.viewModel.selectedSecondAccount = PLQuickBalanceSettingsViewModel.map(accounts?.first(where: {$0.number == id }))
            }

            if self?.viewModel.selectedMainAccount != nil {
                self?.viewModel.isOn = true
            }

            if self?.viewModel.selectedMainAccount == nil {
                self?.viewModel.selectedMainAccount = PLQuickBalanceSettingsViewModel.map(accounts?.first(where: {$0.defaultForPayments == true }))
            }

            if self?.viewModel.selectedMainAccount == nil {
                self?.viewModel.selectedMainAccount = PLQuickBalanceSettingsViewModel.map(accounts?.first)
            }

            if let amount = settings.first?.amount  {
                self?.viewModel.amount = Double(amount)
            }

            self?.updateView()
        })
    }

    @objc func onTapSubmit() {
        let input: PLQuickBalanceSettingsUseCaseInput
        if viewModel.isOn {
            input = PLQuickBalanceSettingsUseCaseInput(accounts: [PLQuickBalanceAccount(accountNo: viewModel.selectedMainAccount?.id,
                                                                                        amount: viewModel.amount),
                                                                  PLQuickBalanceAccount(accountNo: viewModel.selectedSecondAccount?.id,
                                                                                        amount: viewModel.amount)])
        } else {
            input = PLQuickBalanceSettingsUseCaseInput(accounts: [])
        }

        Scenario(useCase: quickBalanceSettingsUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.handleSuccess()
            }
            .onError { [weak self] error in
                self?.view?.showErrorMessage(localized("pl_quickView_text_failedToActivate"), onConfirm: { [weak self] in
                    self?.coordinator.pop()
                })
            }
    }
    
    private func handleSuccess() {
        let message: String
        if self.viewModel.isOn {
            message = localized("pl_quickView_text_turnedOn")
        } else {
            message = localized("pl_quickView_text_turnedOff")
        }
    
        self.view?.showMessage(title: localized("generic_label_done"), message: message, image: "icnCheck", onConfirm: { [weak self] in
            self?.coordinator.pop()
            })
    }

    func onTapSwitch() {
        viewModel.isOn = !viewModel.isOn
        updateView()
    }

    func changeMainAccount() {
        let coordinator = dependenciesResolver.resolve(for: PLQuickBalanceCoordinatorProtocol.self)
        coordinator.showSelectAccountView(viewModel: viewModel,
                                          delegate: self,
                                          accountType: .main)
    }
    
    func changeSecondAccount() {
        let coordinator = dependenciesResolver.resolve(for: PLQuickBalanceCoordinatorProtocol.self)
        coordinator.showSelectAccountView(viewModel: viewModel,
                                          delegate: self,
                                          accountType: .second)
    }

    func updateAmount(amount: Double?) {
        viewModel.amount = amount
    }
}

extension PLQuickBalanceSettingsPresenter: PLQuickBalanceSetAccountViewControllerDelegate {
    func setMain(account: PLQuickBalanceSettingsAccountModel) {
        viewModel.selectedMainAccount = account
        if viewModel.selectedMainAccount == viewModel.selectedSecondAccount {
            viewModel.selectedSecondAccount = nil
        }
        updateView()
    }

    func setSecond(account: PLQuickBalanceSettingsAccountModel?) {
        viewModel.selectedSecondAccount = account
        updateView()
    }
}
