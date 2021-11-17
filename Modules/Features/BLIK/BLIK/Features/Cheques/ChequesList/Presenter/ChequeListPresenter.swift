//
//  ChequeListPresenter.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import UI
import Commons
import DomainCommon

protocol ChequeListPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func didPullToRefresh(completion: (() -> Void)?)
    func didSelectCheque(withId id: Int)
    func didPressCreateCheque()
}

final class ChequeListPresenter: ChequeListPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: ChequesCoordinatorProtocol
    private let listType: ChequeListType
    private let loadChequesUseCase: LoadChequesUseCaseProtocol
    private let loadWalletParamsUseCase: LoadWalletParamsUseCaseProtocol
    private let viewModelMapper: ChequeViewModelMapperProtocol
    private let discardingLock: DiscardingLocking
    private var viewDidAppearBefore = false
    private var fetchedCheques: [BlikCheque] = []
    private var walletParams: WalletParams?
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    weak var view: ChequeListViewProtocol?
    
    init(
        dependenciesResolver: DependenciesResolver,
        coordinator: ChequesCoordinatorProtocol,
        listType: ChequeListType,
        loadChequesUseCase: LoadChequesUseCaseProtocol,
        loadWalletParamsUseCase: LoadWalletParamsUseCaseProtocol,
        viewModelMapper: ChequeViewModelMapperProtocol,
        discardingLock: DiscardingLocking
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = coordinator
        self.listType = listType
        self.loadChequesUseCase = loadChequesUseCase
        self.loadWalletParamsUseCase = loadWalletParamsUseCase
        self.viewModelMapper = viewModelMapper
        self.discardingLock = discardingLock
    }
    
    func viewDidLoad() {
        loadDataWithFullscreenLoader()
    }
    
    func didPullToRefresh(completion: (() -> Void)?) {
        silentlyRefreshData(completion: completion)
    }
    
    func viewDidAppear() {
        if viewDidAppearBefore {
            silentlyRefreshData(completion: nil)
        } else {
            viewDidAppearBefore = true
        }
    }
    
    func didSelectCheque(withId id: Int) {
        guard let cheque = fetchedCheques.first(where: { $0.id == id }) else {
            return
        }
        
        coordinator.showChequeDetails(cheque)
    }
    
    func didPressCreateCheque() {
        guard let params = walletParams else {
            showDialog(
                title: "#Wystąpił błąd!",
                text: "#Nie można utworzyć nowego czeku BLIK. Spróbuj ponownie później"
            )
            return
        }
        if fetchedCheques.count >= params.activeChequesLimit {
            showActiveChequesLimitPopup(limit: params.activeChequesLimit)
        } else {
            coordinator.showChequeCreationFlow(maxChequeAmount: params.maxChequeAmount)
        } 
    }
    
    private func loadDataWithFullscreenLoader() {
        guard let view = view else { return }
        view.showLoadingWithLoading(
            info: .init(
                type: .onScreen(controller: view.associatedLoadingView, completion: nil),
                loadingText: .empty,
                placeholders: nil,
                topInset: nil,
                background: nil,
                loadingImageType: .points,
                style: .global
            )
        )
        view.disableCreateChequeButton()
        
        var chequesResult: Result<[BlikCheque], Swift.Error>?
        var walletParamsResult: Result<WalletParams, Swift.Error>?
        
        let loadChequesScenario = Scenario(
            useCase: loadChequesUseCase,
            input: LoadChequesUseCaseInput(chequeListType: listType)
        )
        
        var scenario = MultiScenario(handledOn: useCaseHandler)
            .addScenario(loadChequesScenario) { updatedValues, output, _ in
                chequesResult = .success(output.chequeList)
            }
            
        if listType == .active {
            let loadWalletScenario = Scenario(useCase: loadWalletParamsUseCase)
            scenario = scenario.addScenario(loadWalletScenario) { updatedValues, output, _ in
                walletParamsResult = .success(output.walletParams)
            }
        }
            
        scenario
            .asScenarioHandler()
            .onSuccess { [weak self] _ in
                self?.walletParams = try? walletParamsResult?.get()
            }
            .onError { [weak self] _ in
                self?.walletParams = try? walletParamsResult?.get()
            }
            .finally { [weak self] in
                self?.updateView(with: chequesResult)
            }
    }
    
    private func updateView(with chequesResult: Result<[BlikCheque], Swift.Error>?) {
        guard let result = chequesResult else {
            self.showChequeListErrorMessage()
            return
        }
        self.handleLoadChequesResult(result)
        self.view?.dismissLoading()
        self.view?.enableCreateChequeButton()
    }
    
    private func silentlyRefreshData(completion: (() -> Void)?) {
        discardingLock.lock { [weak self] releaseBlock in
            guard let strongSelf = self else {
                releaseBlock()
                return
            }
            let input = LoadChequesUseCaseInput(
                chequeListType: strongSelf.listType
            )
            Scenario(useCase: strongSelf.loadChequesUseCase, input: input)
                .execute(on: strongSelf.useCaseHandler)
                .onSuccess { cheques in
                    guard let strongSelf = self else {
                        releaseBlock()
                        return
                    }
                    releaseBlock()
                    strongSelf.handleLoadChequesResult(.success(cheques.chequeList))
                    completion?()
                }
                .onError { error in
                    guard let strongSelf = self else {
                        releaseBlock()
                        return
                    }
                    releaseBlock()
                    strongSelf.handleLoadChequesResult(.failure(error))
                    completion?()
                }
        }
    }
    
    private func handleLoadChequesResult(_ result: Result<[BlikCheque], Swift.Error>) {
        switch result {
        case let .success(cheques):
            fetchedCheques = cheques
            let viewModel = viewModelMapper.map(
                cheques: cheques,
                listType: listType
            )
            view?.setViewModel(viewModel)
        case .failure:
            fetchedCheques = []
            showChequeListErrorMessage()
        }
    }
    
    private func showActiveChequesLimitPopup(limit: Int) {
        let text = ChequeLimitMessageBuilder()
            .withLimit(limit)
            .build()
        
        showDialog(text: text)
    }
    
    private func showDialog(title: LocalizedStylableText = localized("pl_blik_alert_informTitle"),
                            text: LocalizedStylableText) {
        view?.showDialog(title: title, text: text)
    }
    
    private func showChequeListErrorMessage() {
        let title = "#Wystąpił błąd"
        let subtitle = "#Twoja lista czeków nie została poprawnie pobrana. Odśwież listę czeków lub spróbuj ponownie później."
        let refreshAction: ErrorCellViewModel.RefreshButtonAction = { [weak self] in
            self?.loadDataWithFullscreenLoader()
        }
        let viewModel = ErrorCellViewModel(
            title: title,
            subtitle: subtitle,
            refreshButtonState: .present(refreshAction)
        )
        view?.setViewModel(.error(viewModel))
    }
}
