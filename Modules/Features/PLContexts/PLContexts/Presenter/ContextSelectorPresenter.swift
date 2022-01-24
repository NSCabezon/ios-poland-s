//
//  ContextSelectorPresenter.swift
//  PLUI
//
//  Created by Ernesto Fernandez Calles on 22/12/21.
//

import Foundation
import UI
import Commons
import SANPLLibrary

protocol ContextSelectorPresenterProtocol: AnyObject {
    var view: ContextSelectorViewProtocol? {get set}
    func viewHasLoad()
    func didSelectContext(with ownerId: String)
    func didCancel()
    func didShowAllContexts()
}

final class ContextSelectorPresenter {
    
    private let dependenciesResolver: DependenciesResolver
    private let bsanDataProvider: BSANDataProvider
    private var firstSelectedContext: ContextDTO? = nil
    private var contextSelectorCoordinator: ContextSelectorCoordinator {
        self.dependenciesResolver.resolve(for: ContextSelectorCoordinator.self)
    }
    weak var view: ContextSelectorViewProtocol?

    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.bsanDataProvider = bsanDataProvider
    }
}

extension ContextSelectorPresenter: ContextSelectorPresenterProtocol {
    func viewHasLoad() {
        self.trackerManager.trackEvent(screenId: GlobalPositionPage().page, eventId: GlobalPositionContextsPage.Action.unfoldContextList.rawValue, extraParameters: [:])
        self.trackerManager.trackScreen(screenId: GlobalPositionContextsPage().page, extraParameters: [:])
        let getContextsUseCase = GetContextsUseCase(dependenciesResolver: self.dependenciesResolver, bsanDataProvider: self.bsanDataProvider)
        Scenario(useCase: getContextsUseCase, input: () )
            .execute(on: DispatchQueue.main)
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                let colorsEngine: ColorsByNameEngine = self.dependenciesResolver.resolve()
                let contextViewModels = result.contexts.map({ context -> ContextSelectorViewModel in
                    if let selectedContext = context.selected, selectedContext {
                        self.firstSelectedContext = context
                    }
                    let abbreviationColorType = colorsEngine.get(context.name ?? "")
                    let abbreviationColor = ColorsByNameViewModel(abbreviationColorType).color
                    return ContextSelectorViewModel(ownerId: context.ownerId?.getStringValue() ?? "", name: context.name ?? "", type: context.type, abbreviationColor: abbreviationColor, selected: context.selected ?? false)
                })
                self.view?.setupUI(with: contextViewModels)
            }
            .onError { _ in
                self.trackEvent(.apiError)
            }
    }
    
    func didSelectContext(with ownerId: String) {
        guard ownerId != firstSelectedContext?.ownerId?.getStringValue() else {
            self.trackEvent(.selectSame)
            self.contextSelectorCoordinator.dismiss()
            return
        }
        self.trackEvent(.selectNew)
        let putSelectedContextUseCase = PutSelectedContextUseCase(dependenciesResolver: self.dependenciesResolver, bsanDataProvider: self.bsanDataProvider)
        Scenario(useCase: putSelectedContextUseCase, input: PutSelectedContextUseCaseInput(ownerId: ownerId))
            .execute(on: DispatchQueue.main)
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.contextSelectorCoordinator.dismiss()
                let globalPositionReloader = self.dependenciesResolver.resolve(for: GlobalPositionReloader.self)
                globalPositionReloader.reloadGlobalPosition()
            }
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.view?.showGenericErrorDialog(withDependenciesResolver: self.dependenciesResolver, action: {
                    self.contextSelectorCoordinator.dismiss()
                }, closeAction: nil)
                self.trackEvent(.apiError)
            }
    }

    func didCancel() {
        self.trackEvent(.cancel)
        self.contextSelectorCoordinator.dismiss()
    }

    func didShowAllContexts() {
        self.trackEvent(.showAll)
    }
}

extension ContextSelectorPresenter: AutomaticScreenActionTrackable {
    var trackerManager: TrackerManager {
        return self.dependenciesResolver.resolve(for: TrackerManager.self)
    }

    var trackerPage: GlobalPositionContextsPage {
        return GlobalPositionContextsPage()
    }
}
