//
//  RepaymentAmountOptionChooseListPresenter.swift
//  Pods
//
//  Created by 186484 on 07/06/2021.
//

import CoreFoundationLib
import Commons

protocol RepaymentAmountOptionChooseListPresenterProtocol: MenuTextWrapperProtocol {
    var view: RepaymentAmountOptionChooseListViewProtocol? { get set }
    var repayments: [RepaymentAmountOptionChooseListViewModel] { get }
    
    func viewDidLoad()
    func didSelectItem(at indexPath: IndexPath)
    func didConfirmClosing()
    func backButtonSelected()
}

final class RepaymentAmountOptionChooseListPresenter {
    weak var view: RepaymentAmountOptionChooseListViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    var repayments: [RepaymentAmountOptionChooseListViewModel] = []
    var repaymentsOptions: [CreditCardRepaymentAmountOption] = []

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getRepaymentsUseCase: GetCreditCardRepaymentAmountOptionsUseCase {
        return dependenciesResolver.resolve(for: GetCreditCardRepaymentAmountOptionsUseCase.self)
    }
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
}

private extension RepaymentAmountOptionChooseListPresenter {
    var coordinator: RepaymentAmountOptionChooseListCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: RepaymentAmountOptionChooseListCoordinatorProtocol.self)
    }
}

extension RepaymentAmountOptionChooseListPresenter: RepaymentAmountOptionChooseListPresenterProtocol {
       
    func viewDidLoad() {
        loadRepayments()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let repaymentOption = repaymentsOptions[indexPath.item]
        formManager.setRepaymentType(repaymentOption.type, withAmount: repaymentOption.amount)
        reloadData()
        coordinator.goBack()
    }
    
    func didConfirmClosing() {
        coordinator.onCloseConfirmed?()
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    private func loadRepayments() {
        guard let creditCard = formManager.form.creditCard else {
            fatalError("Should have credit card selected at this point")
        }
        let input = GetCreditCardRepaymentAmountOptionsUseCaseInput(creditCard: creditCard)
        Scenario(useCase: getRepaymentsUseCase, input: input)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                guard let self = self else { return }
                self.repaymentsOptions = output.options
                self.reloadData()
            }.onError { _ in
                self.view?.showGenericErrorDialog(
                    withDependenciesResolver: self.dependenciesResolver,
                    closeAction: { [weak self] in
                        self?.coordinator.goBack()
                    }
                )
            }
    }
    
    private func reloadData() {
        self.repayments = repaymentsOptions.map {
            let repaymentValue: String?
            if let amount = $0.amount?.getFormattedDisplayValueAndCurrency(with: NumberFormatter.PLAmountNumberFormatterWithoutCurrency) {
                repaymentValue = amount
            } else if $0.type == .other {
                repaymentValue = localized("pl_creditCard_text_repTypeOtherVal")
            } else {
                repaymentValue = nil
            }
            return RepaymentAmountOptionChooseListViewModel(
                repaymentName: $0.type.localized,
                repaymentValue: repaymentValue,
                isSelected: self.formManager.form.repaymentType == $0.type)
        }
        self.view?.reloadTableView()
    }
    
}

extension RepaymentAmountOptionChooseListPresenter: AutomaticScreenActionTrackable {
    var trackerPage: RepaymentAmountOptionChooseListPage {
        RepaymentAmountOptionChooseListPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

//TODO:
//Change it in future
public struct RepaymentAmountOptionChooseListPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }
    public init() {}
}
