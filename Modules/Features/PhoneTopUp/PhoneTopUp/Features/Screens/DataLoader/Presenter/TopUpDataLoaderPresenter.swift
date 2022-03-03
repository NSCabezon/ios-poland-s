//
//  TopUpDataLoaderPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/02/2022.
//

import CoreFoundationLib
import Foundation
import Operative
import PLCommons
import PLUI

protocol TopUpDataLoaderPresenterProtocol: AnyObject {
    var view: TopUpDataLoaderViewProtocol? { get set }
    func viewDidLoad()
}

final class TopUpDataLoaderPresenter {
    // MARK: Properties
    weak var view: TopUpDataLoaderViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: TopUpDataLoaderCoordinatorProtocol?
    private let settings: TopUpSettings
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, settings: TopUpSettings) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpDataLoaderCoordinatorProtocol.self)
        self.settings = settings
    }
}

extension TopUpDataLoaderPresenter: TopUpDataLoaderPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: GetPhoneTopUpFormDataUseCase(dependenciesResolver: self.dependenciesResolver))
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.handleSuccessfulDataFetch(with: output)
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: {
                        self?.coordinator?.close()
                    })
                })
            }

    }
    
    private func handleSuccessfulDataFetch(with fetchedData: GetPhoneTopUpFormDataOutput) {
        guard !fetchedData.accounts.isEmpty else {
            view?.hideLoader(completion: { [weak self] in
                self?.view?.showErrorMessage(title: localized("pl_popup_noSourceAccTitle"),
                                            message: localized("pl_popup_noSourceAccParagraph"),
                                            image: "icnInfoGray",
                                            onConfirm: {
                    self?.coordinator?.close()
                })
            })
            return
        }
        
        let formData = TopUpPreloadedFormData(accounts: fetchedData.accounts,
                                              operators: fetchedData.operators,
                                              gsmOperators: fetchedData.gsmOperators,
                                              internetContacts: fetchedData.internetContacts,
                                              settings: settings)
        view?.hideLoader(completion: { [weak self] in
            self?.coordinator?.showForm(with: formData)
        })
    }
}
