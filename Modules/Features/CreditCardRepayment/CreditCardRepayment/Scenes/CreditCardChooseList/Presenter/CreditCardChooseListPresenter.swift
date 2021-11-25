//
//  CreditCardChooseListPresenter.swift
//  Pods
//
//  Created by 186490 on 01/06/2021.
//  

import Models
import Commons
import CoreFoundationLib
import Operative

protocol CreditCardChooseListPresenterProtocol: OperativeStepPresenterProtocol, MenuTextWrapperProtocol {
    var view: CreditCardChooseListViewProtocol? { get set }
    
    func viewDidLoad()
    func didSelectItem(at indexPath: IndexPath)
    func didConfirmClosing()
    func backButtonSelected()
}

final class CreditCardChooseListPresenter {
    
    var number: Int = 0
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = true
    var isCancelButtonEnabled: Bool = true
    
    weak var view: CreditCardChooseListViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var subscriber: CreditCardRepaymentFormManager.Subscriber?
    
    var creditCardsEntities: [CCRCardEntity] = []

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private var getCreditCardsUseCase: GetCreditCardsUseCase {
        return dependenciesResolver.resolve(for: GetCreditCardsUseCase.self)
    }
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
    
    deinit {
        subscriber?.remove()
    }
}

extension CreditCardChooseListPresenter: CreditCardChooseListPresenterProtocol {
   
    func viewDidLoad() {
        loadCards()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        formManager.setCreditCard(creditCardsEntities[indexPath.item])
        container?.stepFinished(presenter: self)
    }

    func didConfirmClosing() {
        container?.dismissOperative()
    }
    
    func backButtonSelected() {
        container?.dismissOperative()
    }
    
    private func loadCards() {
        Scenario(useCase: getCreditCardsUseCase)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.creditCardsEntities = result.cards
                self.reloadData()
            }
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.view?.showError(
                    closeAction: { [weak self] in
                        self?.container?.dismissOperative()
                    }
                )
            }
    }
    
    private func reloadData() {
        let creditCards = creditCardsEntities.map {
            CreditCardChooseListViewModel(
                creditCardName: $0.alias,
                lastCreditCardDigits: "*" + String($0.displayPan.suffix(4))
            )
        }
        view?.setup(with: creditCards)
    }
}

extension CreditCardChooseListPresenter: AutomaticScreenActionTrackable {
    var trackerPage: CreditCardChooseListPage {
        CreditCardChooseListPage()
    }
    var trackerManager: TrackerManager {
        self.dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

//TODO:
//Change it in future
public struct CreditCardChooseListPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "CreditCardChooseListPage"
    
    public enum Action: String {
        case apply = "example"
    }
    public init() {}
}
