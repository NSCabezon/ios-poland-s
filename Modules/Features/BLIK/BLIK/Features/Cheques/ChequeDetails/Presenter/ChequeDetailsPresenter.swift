//
//  ChequeDetailsPresenter.swift
//  BLIK
//
//  Created by 186491 on 16/06/2021.
//

import UIKit
import UI
import CoreFoundationLib

protocol ChequeDetailsPresenterProtocol {
    func viewDidLoad(completion: (ChequeDetailsViewModel) -> Void)
    func didPressSend()
    func didPressRemove()
    func didPressClose()
}

final class ChequeDetailsPresenter {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: ChequesCoordinatorProtocol
    private let cheque: BlikCheque
    private let viewModelMapper: ChequeDetailsViewModelMapperProtocol
    private let removeUserCase: RemoveChequeUseCaseProtocol
    private var viewModel: ChequeDetailsViewModel?
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: ChequeDetailsViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: ChequesCoordinatorProtocol,
        cheque: BlikCheque,
        removeUserCase: RemoveChequeUseCaseProtocol,
        viewModelMapper: ChequeDetailsViewModelMapperProtocol
    ) {
        self.dependenciesResolver = dependenciesResolver
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
            let input = RemoveChequeUseCaseInput(
                chequeId: strongSelf.cheque.id
            )
            strongSelf.view?.showLoader()
            Scenario(
                useCase: strongSelf.removeUserCase, input: input)
                .execute(on: strongSelf.useCaseHandler)
                .onSuccess { [weak self] in
                    self?.view?.hideLoader(completion: {
                        self?.showSuccessMessageAndGoBack()
                    })
                }
                .onError { [weak self] error in
                    self?.view?.hideLoader(completion: {
                        self?.view?.showServiceInaccessibleMessage(onConfirm: nil)
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

