//
//  PLHelpCenterPresenter.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//

import Models
import Commons
import CoreFoundationLib
import UI

protocol LoanScheduleListPresenterProtocol: MenuTextWrapperProtocol {
    var view: LoanScheduleListViewProtocol? { get set }
    var loanScheduleIdentity: LoanScheduleIdentity? { get set }

    func viewDidLoad()
    func backButtonSelected()
}

final class LoanScheduleListPresenter {
    weak var view: LoanScheduleListViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    var loanScheduleIdentity: LoanScheduleIdentity?
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
}

private extension LoanScheduleListPresenter {
    var coordinator: LoanScheduleListCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: LoanScheduleListCoordinatorProtocol.self)
    }
    
    var getGetLoanScheduleUseCase: GetLoanScheduleUseCaseProtocol {
        dependenciesResolver.resolve(for: GetLoanScheduleUseCaseProtocol.self)
    }
}

extension LoanScheduleListPresenter: LoanScheduleListPresenterProtocol {
    
    func viewDidLoad() {
        loadSchedules()
    }
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    private func loadSchedules() {
        self.view?.showLoading()
        
        if let loanName = loanScheduleIdentity?.loanName {
            view?.setUp(information: LoanScheduleListInformationViewModel(title: loanName))
        }
        
        guard let accountNumber = loanScheduleIdentity?.loanAccountNumber else {
            fatalError("loanAccountNumber can not be nil at this point")
        }

        let input = GetLoanScheduleUseCaseInput(accountNumber: accountNumber)
        Scenario(useCase: getGetLoanScheduleUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] result in
                let viewModels: [LoanScheduleListItemViewModel] = result.schedules.items.map { item in
                    return LoanScheduleListItemViewModel(
                        repaymentValue: item.amount.getFormattedAmountUI(),
                        repaymentDate: item.date.toString(format: TimeFormat.ddMMyyyy.rawValue),
                        description: localized("pl_loanSchedule_label_capitalBalance"),
                        loanTotal: item.balanceAfterPayment.getFormattedAmountUI(),
                        onItemTap: {
                            self?.coordinator.goToDetails(with: item)
                        }
                    )
                }
                self?.view?.dismissLoading(completion: {
                    self?.view?.setUp(items: viewModels)
                })
            }
            .onError { [weak self] _ in
                self?.view?.dismissLoading(completion: { [weak self] in
                    self?.view?.showError(closeAction: { [weak self] in
                        self?.coordinator.goBack()
                    })
                })
            }
    }
}
