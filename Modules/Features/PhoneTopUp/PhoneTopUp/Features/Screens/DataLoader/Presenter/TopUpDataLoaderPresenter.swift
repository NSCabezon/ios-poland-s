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
    private let useCase: GetPhoneTopUpFormDataUseCaseProtocol
    private var coordinator: TopUpDataLoaderCoordinatorProtocol?
    private let settings: TopUpSettings
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, settings: TopUpSettings) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: TopUpDataLoaderCoordinatorProtocol.self)
        self.useCase = dependenciesResolver.resolve(for: GetPhoneTopUpFormDataUseCaseProtocol.self)
        self.settings = settings
    }
}

extension TopUpDataLoaderPresenter: TopUpDataLoaderPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: useCase)
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
        
        let operators = filterOperatorsWithoutSettings(operators: fetchedData.operators, settings: settings)
        guard !operators.isEmpty else {
            view?.hideLoader(completion: { [weak self] in
                self?.view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: {
                    self?.coordinator?.close()
                })
            })
            return
        }
        
        let formData = TopUpPreloadedFormData(accounts: fetchedData.accounts,
                                              operators: operators,
                                              internetContacts: fetchedData.internetContacts,
                                              settings: settings,
                                              topUpAccount: fetchedData.topUpAccount)
        view?.hideLoader(completion: { [weak self] in
            self?.coordinator?.showForm(with: formData)
        })
    }
    
    private func filterOperatorsWithoutSettings(operators: [Operator], settings: TopUpSettings) -> [Operator] {
        let operatorsWithSettings = Set(settings.map(\.operatorId))
        return operators.filter({ operatorsWithSettings.contains($0.id) })
    }
}
