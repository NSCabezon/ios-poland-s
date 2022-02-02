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
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpDataLoaderCoordinatorProtocol.self)
    }
}

extension TopUpDataLoaderPresenter: TopUpDataLoaderPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: GetPhoneTopUpFormDataUseCase(dependenciesResolver: self.dependenciesResolver))
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] formData in
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
