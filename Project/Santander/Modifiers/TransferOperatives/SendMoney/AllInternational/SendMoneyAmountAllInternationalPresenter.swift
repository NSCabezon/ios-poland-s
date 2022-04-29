//
//  SendMoneyAmountAllInternationalPresenter.swift
//  TransferOperatives
//
//  Created by José María Jiménez Pérez on 20/4/22.
//

import CoreFoundationLib
import Operative
import CoreDomain
import TransferOperatives

protocol SendMoneyAmountAllInternationalPresenterProtocol: OperativeStepPresenterProtocol {
    var view: SendMoneyAmountAllInternationalView? { get set }
    func viewDidLoad()
    func didSelectBack()
    func didSelectClose()
    func getSubtitleInfo() -> String
    func didSelectContinue()
    func getStepOfSteps() -> [Int]
    func changeOriginAccount()
    func changeDestinationAccount()
    func saveDescription(_ description: String?)
    func saveSwift(_ swift: String?)
}

final class SendMoneyAmountAllInternationalPresenter {
    var number: Int = 0
    var isBackButtonEnabled: Bool = false
    var isCancelButtonEnabled: Bool = false
    var container: OperativeContainerProtocol?
    weak var view: SendMoneyAmountAllInternationalView?
    private let dependenciesResolver: DependenciesResolver
    lazy var operativeData: SendMoneyOperativeData = {
        guard let container = self.container else { fatalError() }
        return container.get()
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension SendMoneyAmountAllInternationalPresenter {
    var destinationIban: IBANRepresentable? {
        return self.operativeData.destinationIBANRepresentable
    }
    
    var sendMoneyModifier: SendMoneyModifierProtocol? {
        return self.dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)
    }
    
    var sendMoneyUseCaseProvider: SendMoneyUseCaseProviderProtocol {
        return self.dependenciesResolver.resolve()
    }
    
    var isSwiftRangeValid: Bool {
        guard let swift = self.operativeData.bicSwift, swift.isNotEmpty else { return false }
        return swift.count > 7 && swift.count < 12
    }
    
    var isFloatingButtonEnabled: Bool {
        return self.isSwiftRangeValid && true // TODO: add here oneExangeRateValidations
    }
    
    func setAccountSelectorView() {
        guard let selectedAccount = self.operativeData.selectedAccount,
              let destinationIban = self.destinationIban
        else { return }
        var originImage: String?
        if let mainAcount = self.operativeData.mainAccount, mainAcount.equalsTo(other: selectedAccount) {
            originImage = "icnHeartTint"
        }
        let amountType = self.sendMoneyModifier?.amountToShow ?? .currentBalance
        let viewModel = OneAccountsSelectedCardViewModel(
            statusCard: .expanded(
                OneAccountsSelectedCardExpandedViewModel(
                    destinationIban: destinationIban,
                    destinationAlias: self.operativeData.destinationAlias ?? self.operativeData.destinationName,
                    destinationCountry: self.operativeData.destinationCountryName ?? ""
                )
            ),
            originAccount: selectedAccount,
            originImage: originImage,
            amountToShow: amountType
        )
        self.view?.addAccountSelector(viewModel)
    }
    
    func loadExchangeRates() {
        guard self.operativeData.exchangeRates == nil else { return }
        let useCase = self.sendMoneyUseCaseProvider.getExchangeRatesUseCase()
        Scenario(useCase: useCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.operativeData.exchangeRates = output.exchangeRates
                // TODO: configure oneExangeRateView
            }
            .onError { [weak self] _ in
                self?.container?.showGenericError()
            }
    }
}

extension SendMoneyAmountAllInternationalPresenter: SendMoneyAmountAllInternationalPresenterProtocol {
    func viewDidLoad() {
        self.setAccountSelectorView()
        self.loadExchangeRates()
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
    }
    
    func didSelectClose() {
        self.container?.close()
    }
    
    func didSelectBack() {
        self.container?.back()
    }
    
    func getSubtitleInfo() -> String {
        self.container?.getSubtitleInfo(presenter: self) ?? ""
    }
    
    func didSelectContinue() {
        
    }
    
    func getStepOfSteps() -> [Int] {
        self.container?.getStepOfSteps(presenter: self) ?? []
    }
    
    func changeOriginAccount() {
        self.container?.back(
            to: SendMoneyAccountSelectorPresenter.self,
            creatingAt: 0,
            step: SendMoneyAccountSelectorStep(dependenciesResolver: self.dependenciesResolver))
    }
    
    func changeDestinationAccount() {
        self.container?.back(
            to: SendMoneyDestinationAccountPresenter.self,
            creatingAt: 0,
            step: SendMoneyDestinationStep(dependenciesResolver: self.dependenciesResolver))
    }
    
    func saveDescription(_ description: String?) {
        self.operativeData.description = description
    }
    
    func saveSwift(_ swift: String?) {
        self.operativeData.bicSwift = swift
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
    }
}
