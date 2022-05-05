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
    func saveAmounts(originAmount: AmountRepresentable, destinationAmount: AmountRepresentable)
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
    
    var isAmountValid: Bool {
        let amount = self.operativeData.amount?.value ?? 0
        return amount > 0
    }
    
    var isFloatingButtonEnabled: Bool {
        return self.isSwiftRangeValid && self.isAmountValid
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
    
    func loadExchangeRates(completion: @escaping () -> Void) {
        guard self.operativeData.exchangeRates == nil else {
            completion()
            return
        }
        let useCase = self.sendMoneyUseCaseProvider.getExchangeRatesUseCase()
        Scenario(useCase: useCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                self?.operativeData.exchangeRates = output.exchangeRates
                completion()
            }
            .onError { [weak self] _ in
                self?.container?.showGenericError()
            }
    }
    
    func getOneExchangeViewModel() -> OneExchangeRateAmountViewModel? {
        if self.operativeData.amount == nil {
            guard let originCurrency = self.operativeData.selectedAccount?.currencyRepresentable,
                  let destinationCurrency = self.getDestinationCurrencyRepresentable()
            else { return nil }
            self.operativeData.amount = AmountRepresented(value: 0, currencyRepresentable: originCurrency)
            self.operativeData.receiveAmount = AmountRepresented(value: 0, currencyRepresentable: destinationCurrency)
        }
        guard let originAmount = self.operativeData.amount,
              let originCurrency = originAmount.currencyRepresentable,
              let originRates = self.getBuySellRatesForCurrency(originCurrency),
              let destinationAmount = self.operativeData.receiveAmount,
              let destinationCurrency = destinationAmount.currencyRepresentable,
              let destinationRates = self.getBuySellRatesForCurrency(destinationCurrency)
        else { return nil }
        return OneExchangeRateAmountViewModel(originAmount:
                                        OneExchangeRateAmount(amount: originAmount, buyRate: originRates.buyRate, sellRate: originRates.sellRate),
                                       type: .exchange(destinationAmount:
                                                        OneExchangeRateAmount(amount: destinationAmount, buyRate: destinationRates.buyRate, sellRate: destinationRates.sellRate)))
    }
    
    func getBuySellRatesForCurrency(_ currency: CurrencyRepresentable) -> (buyRate: AmountRepresentable, sellRate: AmountRepresentable)? {
        if currency.currencyCode == "PLN" {
            return (AmountRepresented(value: 1, currencyRepresentable: currency), AmountRepresented(value: 1, currencyRepresentable: currency))
        } else {
            guard let exchangeRates = self.operativeData.exchangeRates,
                  let foundCurrency = exchangeRates.first(where: { $0.currencyCode == currency.currencyCode })
            else { return nil }
            return (foundCurrency.buyRateRepresentable, foundCurrency.sellRateRepresentable)
        }
    }
    
    func getDestinationCurrencyRepresentable() -> CurrencyRepresentable? {
        // TODO: swap for hardcoded EUR when working change country
//        guard let currencyCode = self.operativeData.currency?.code ?? self.operativeData.currencyName else { return nil }
        let currencyCode = "EUR"
        return CurrencyRepresented(currencyCode: currencyCode)
    }
}

extension SendMoneyAmountAllInternationalPresenter: SendMoneyAmountAllInternationalPresenterProtocol {
    func viewDidLoad() {
        self.setAccountSelectorView()
        self.loadExchangeRates { [weak self] in
            guard let viewModel = self?.getOneExchangeViewModel() else { return }
            self?.view?.setExchangeRateViewModel(viewModel)
        }
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
    
    func saveAmounts(originAmount: AmountRepresentable, destinationAmount: AmountRepresentable) {
        self.operativeData.amount = originAmount
        self.operativeData.receiveAmount = destinationAmount
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
    }
}
