//
//  ChequeDetailsPresenter.swift
//  BLIK
//
//  Created by 186491 on 16/06/2021.
//

import UIKit
import UI
import Commons

protocol ChequeDetailsPresenterProtocol {
    func viewDidLoad(completion: (ChequeDetailsViewModel) -> Void)
    func didPressSend()
    func didPressRemove()
    func didPressClose()
}

final class ChequeDetailsPresenter {
    private let coordinator: ChequesCoordinatorProtocol
    private let cheque: BlikCheque
    private let viewModelMapper: ChequeDetailsViewModelMapperProtocol
    private let removeUserCase: RemoveChequeUseCaseProtocol
    private var viewModel: ChequeDetailsViewModel?
    weak var view: ChequeDetailsViewProtocol?
    
    init(coordinator: ChequesCoordinatorProtocol,
         cheque: BlikCheque,
         removeUserCase: RemoveChequeUseCaseProtocol,
         viewModelMapper: ChequeDetailsViewModelMapperProtocol
    ) {
        self.coordinator = coordinator
        self.cheque = cheque
        self.viewModelMapper = viewModelMapper
        self.viewModel = viewModelMapper.map(cheque: cheque)
        self.removeUserCase = removeUserCase
    }
}

extension ChequeDetailsPresenter: ChequeDetailsPresenterProtocol {
    func viewDidLoad(completion: (ChequeDetailsViewModel) -> Void) {
        completion(viewModelMapper.map(cheque: cheque))
    }
    
    func didPressSend() {
        coordinator.showShareSheet(cheque: cheque)
    }
    
    func didPressClose() {
        coordinator.pop()
    }
    
    func didPressRemove() {
        coordinator.showRemoveChequeConfirmationAlert { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.view?.showLoader()
            Scenario(useCase: strongSelf.removeUserCase, input: strongSelf.cheque.id)
                .execute(on: DispatchQueue.global())
                .onSuccess { [weak self] in
                    self?.view?.hideLoader(completion: {
                        self?.showSuccessMessageAndGoBack()
                    })
                }
                .onError { [weak self] error in
                    self?.view?.hideLoader(completion: {
                        self?.view?.displayErrorMessage("#Wystąpił błąd w usuwaniu czeku. Spróbuj ponownie.")
                    })
                }
        }
    }
}

private extension ChequeDetailsPresenter {
    private func showSuccessMessageAndGoBack() {
        TopAlertController.setup(TopAlertView.self).showAlert(localized("pl_blik_text_deletedSuccess"), alertType: .info, position: .top)
        coordinator.pop()
    }
}
