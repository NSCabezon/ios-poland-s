import Foundation
import Operative
import PLCommons
import PLCommonOperatives
import CoreFoundationLib

protocol SplitPaymentModulePresenterProtocol: AnyObject {
    var view: SplitPaymentModuleViewProtocol? { get set }
    func viewDidLoad()
}

final class SplitPaymentModulePresenter {
    weak var view: SplitPaymentModuleViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: SplitPaymentModuleCoordinatorProtocol?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(
            for: SplitPaymentModuleCoordinatorProtocol.self
        )
    }
}

extension SplitPaymentModulePresenter: SplitPaymentModulePresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(
            useCase: GetAccountsForDebitUseCase(
                transactionType: .splitPayment,
                dependenciesResolver: dependenciesResolver
            )
        )
        .execute(on: dependenciesResolver.resolve())
        .onSuccess { [weak self] accounts in
            guard let self = self else { return }
            self.view?.hideLoader(completion: {
                if accounts.isEmpty {
                    self.showErrorView()
                    return
                }
                if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
                    let selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? accounts.first?.number ?? ""
                    self.coordinator?.showSplitPaymentForm(with: accounts, selectedAccountNumber: selectedAccountNumber)
                } else {
                    self.coordinator?.showSplitPaymentAccountSelector(with: accounts)
                }
            })
        }
        .onError { [weak self] _ in
            self?.view?.hideLoader(completion: {
                self?.showErrorView()
            })
        }
    }
    
    private func showErrorView() {
        view?.showErrorMessage(title: localized("#pl_split_payment_no_accounts_title_alert_error"),
                               message: localized("#pl_split_payment_no_accounts_description_alert_error"),
                               image: "icnInfo",
                               onConfirm: { [weak self] in
            self?.coordinator?.close()
        })
    }
}
