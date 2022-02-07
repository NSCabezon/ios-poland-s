//
//  TopUpDataLoaderPresenter.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/02/2022.
//

import Commons
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
                let formData = TopUpPreloadedFormData(accounts: output.accounts,
                                                      operators: output.operators,
                                                      gsmOperators: output.gsmOperators,
                                                      internetContacts: output.internetContacts,
                                                      settings: self?.settings ?? [])
                self?.view?.hideLoader(completion: {
                    self?.coordinator?.showForm(with: formData)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: {
                        self?.coordinator?.close()
                    })
                })
            }

    }
}
