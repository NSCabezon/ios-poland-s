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

protocol SendMoneyAmountAllInternationalPresenterProtocol: OperativeStepPresenterProtocol, SendMoneyCurrencyHelperPresenterProtocol {
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
    func didSelectIssueDate(_ date: Date)
    func didSelecteOneFilterSegment(_ type: SendMoneyDateTypeViewModel)
}

final class SendMoneyAmountAllInternationalPresenter {
    var number: Int = 0
    var isBackButtonEnabled: Bool = false
    var isCancelButtonEnabled: Bool = false
    var container: OperativeContainerProtocol?
    weak var view: SendMoneyAmountAllInternationalView?
    internal let dependenciesResolver: DependenciesResolver
    lazy var operativeData: SendMoneyOperativeData = {
        guard let container = self.container else { fatalError() }
        return container.get()
    }()
    
    private var selectedIssueDate: Date?
    
    public var sendMoneyUseCaseProvider: SendMoneyUseCaseProviderProtocol {
        return self.dependenciesResolver.resolve()
    }
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension SendMoneyAmountAllInternationalPresenter {
    enum Constants {
        enum Flags {
            static let format: String = "%@%@%@%@"
            static let urlExtension: String = "RWD/country/icons/"
            static let imageExtension: String = ".png"
        }
    }
    
    var destinationIban: IBANRepresentable? {
        return self.operativeData.destinationIBANRepresentable
    }
    
    var sendMoneyModifier: SendMoneyModifierProtocol? {
        return self.dependenciesResolver.resolve(forOptionalType: SendMoneyModifierProtocol.self)
    }
    
    var isSwiftRangeValid: Bool {
        guard let swift = self.operativeData.bicSwift, swift.isNotEmpty else { return false }
        return swift.count > 7 && swift.count < 12
    }
    
    var isAmountValid: Bool {
        let amount = self.operativeData.amount?.value ?? 0
        return amount > 0
    }
    
    var isDescriptionValid: Bool {
        return self.operativeData.description?.isNotEmpty ?? false
    }
    
    var isFloatingButtonEnabled: Bool {
        return self.isSwiftRangeValid && self.isAmountValid && self.isDescriptionValid
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
        guard let originAmount = self.operativeData.amount,
              let originCurrency = originAmount.currencyRepresentable,
              let originRates = self.getBuySellRatesForCurrency(originCurrency),
              let destinationAmount = self.operativeData.receiveAmount,
              let destinationCurrency = destinationAmount.currencyRepresentable,
              let destinationRates = self.getBuySellRatesForCurrency(destinationCurrency)
        else { return nil }
        let checkSameCurrencies = originCurrency.currencyCode == destinationCurrency.currencyCode
        let typeExchange = getTypeTransactionExchange(destinationAmount: destinationAmount, destinationRates: destinationRates)
        let originExchangeAmount = OneExchangeRateAmount(amount: originAmount,
                                                 buyRate: originRates.buyRate,
                                                 sellRate: originRates.sellRate,
                                                         currencySelector: getOriginCurrenciesView(checkSameCurrencies, type: typeExchange))
        let alert = checkSameCurrencies ? nil : OneExchangeRateAmountAlert(iconName: "icnInfo", titleKey: "sendMoney_label_conversionExchangeRate")
        return OneExchangeRateAmountViewModel(originAmount: originExchangeAmount,
                                              type: typeExchange,
                                              alert: alert
        )
    }
    
    func getOriginCurrenciesView(_ checkSameCurrencies: Bool, type: OneExchangeRateAmountViewType) -> UIView? {
        guard case .noExchange = type else { return nil }
        guard operativeData.transactionalOriginCurrency?.code != getLocalCurrency() || (checkSameCurrencies && self.operativeData.country?.code != getLocalCode()) else {
            return nil
        }
        return self.view?.currenciesSelectionView
    }
    
    func getDestinationCurrenciesView() -> UIView? {
        return self.view?.currenciesSelectionView
    }
    
    func getTypeTransactionExchange(destinationAmount: AmountRepresentable, destinationRates: (buyRate: AmountRepresentable, sellRate: AmountRepresentable)) -> OneExchangeRateAmountViewType {
        let sameCurrencies = self.operativeData.transactionalOriginCurrency?.code == self.operativeData.destinationCurrency?.code
        let typeExchange = sameCurrencies ? OneExchangeRateAmountViewType.noExchange
        : .exchange(destinationAmount:
                        OneExchangeRateAmount(amount: destinationAmount,
                                              buyRate: destinationRates.buyRate,
                                              sellRate: destinationRates.sellRate,
                                              currencySelector: getDestinationCurrenciesView()))
        return typeExchange
    }
    
    func getBuySellRatesForCurrency(_ currency: CurrencyRepresentable) -> (buyRate: AmountRepresentable, sellRate: AmountRepresentable)? {
        if currency.currencyCode == getLocalCurrency() {
            return (AmountRepresented(value: 1, currencyRepresentable: currency), AmountRepresented(value: 1, currencyRepresentable: currency))
        } else {
            guard let exchangeRates = self.operativeData.exchangeRates,
                  let foundCurrency = exchangeRates.first(where: { $0.currencyCode == currency.currencyCode })
            else { return nil }
            return (foundCurrency.buyRateRepresentable, foundCurrency.sellRateRepresentable)
        }
    }
    
    func getLocalCurrency() -> String {
        let countryCode = getLocalCode()
        let countryCurrency = self.operativeData.sepaList?.allCountriesRepresentable.first(where: { $0.code == countryCode })
        return countryCurrency?.currency ?? ""
    }
    
    func getLocalCode() -> String {
        return self.dependenciesResolver.resolve(for: LocalAppConfig.self).countryCode
    }
    
    func getCountryFlag() -> String? {
        guard let baseUrl = self.dependenciesResolver.resolve(for: BaseURLProvider.self).baseURL else {
            return nil
        }
        return String(format: Constants.Flags.format,
                      baseUrl,
                      Constants.Flags.urlExtension,
                      self.operativeData.destinationIBANRepresentable?.countryCode.lowercased() ?? "",
                      Constants.Flags.imageExtension)
    }
    
    func getSwiftBranch() {
        self.view?.showSwiftInfoLoading()
        let useCase = self.sendMoneyUseCaseProvider.getSwiftBranchesUseCase()
        Scenario(useCase: useCase, input: self.operativeData)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { [unowned self] output in
                self.view?.setSwiftInfo(countryFlag: self.getCountryFlag(),
                                        bankName: output.bankName,
                                        bankAddress: output.bankAddress)
                self.view?.hideSwiftInfoLoading()
            }
            .onError { [unowned self] _ in
                self.view?.hideSwiftInfoLoading()
                self.view?.setSwiftError(.invalidSwift)
            }
    }
    
    func setSelectDateOneViewModels() {
        guard let selectionDateOneFilterViewModel = self.sendMoneyModifier?.selectionDateOneFilterViewModel,
              let freqOneInputSelectViewModel = self.sendMoneyModifier?.freqOneInputSelectViewModel,
              let selectionIssueDateViewModel = self.sendMoneyModifier?.selectionIssueDateViewModel
        else { return }
        let bussinessOneInputSelectViewModel = self.sendMoneyModifier?.bussinessOneInputSelectViewModel
        let settedSelectionDateOneFilterViewModel = self.setSelectionDateOneFilterViewModel(selectionDateOneFilterViewModel)
        let issueDateViewModel = OneInputDateViewModel(dependenciesResolver: self.dependenciesResolver,
                                                       status: .activated,
                                                       firstDate: self.operativeData.issueDate,
                                                       minDate: selectionIssueDateViewModel.minDate,
                                                       maxDate: selectionIssueDateViewModel.maxDate)
        self.selectedIssueDate = self.operativeData.transferDateType == .day ? self.operativeData.issueDate : nil
        let viewModel = SelectDateOneContainerViewModel(selectionDateOneFilterViewModel: settedSelectionDateOneFilterViewModel,
                                                        oneInputSelectFrequencyViewModel: freqOneInputSelectViewModel,
                                                        oneInputSelectViewModel: bussinessOneInputSelectViewModel,
                                                        oneInputDateViewModel: issueDateViewModel,
                                                        dependenciesResolver: self.dependenciesResolver)
        self.view?.addSelectDateOneContainerView(viewModel, isSelectDeadlineCheckbox: false, endDate: self.operativeData.endDate)
    }
    
    func setSelectionDateOneFilterViewModel(_ selectionDateOneFilterViewModel: SelectionDateOneFilterViewModel) -> SelectionDateOneFilterViewModel {
        var viewModel = selectionDateOneFilterViewModel
        var index = 0
        if let tranferType = self.operativeData.transferDateType {
            switch tranferType {
            case .day: index = 1
            case .periodic: index = 2
            default: index = 0
            }
        } else {
            index = 0
        }
        viewModel.setSelectedIndex(index)
        return viewModel
    }
}

extension SendMoneyAmountAllInternationalPresenter: SendMoneyAmountAllInternationalPresenterProtocol {
    
    var currenciesList: [CurrencyInfoRepresentable] {
        let filter: [CurrencyInfoRepresentable]? = self.operativeData.sepaList?.allCurrenciesRepresentable.filter { sepaListItem in
            guard sepaListItem.code != getLocalCurrency() else { return true }
            return self.operativeData.exchangeRates?.contains(where: { exchangeRate in
                exchangeRate.currencyCode == sepaListItem.code
            }) ?? false
        }
        return filter ?? []
    }
    
    func viewDidLoad() {
        self.setSelectDateOneViewModels()
        self.setAccountSelectorView()
        self.reloadExchangeRateView()
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
        self.view?.setSwiftText(self.operativeData.bicSwift)
        self.view?.setSwiftInfo(countryFlag: self.getCountryFlag(),
                                bankName: self.operativeData.bankName,
                                bankAddress: self.operativeData.bankAddress)
        self.view?.setDescriptionText(self.operativeData.description)
    }
    
    func reloadExchangeRateView() {
        self.loadExchangeRates { [weak self] in
            guard let viewModel = self?.getOneExchangeViewModel() else { return }
            self?.view?.setExchangeRateViewModel(viewModel)
            self?.checkSimpleDate()
            self?.checkSwiftVew()
        }
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
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
    }
    
    func saveSwift(_ swift: String?) {
        self.operativeData.bicSwift = swift
        guard self.isSwiftRangeValid else {
            self.view?.setSwiftError(.invalidLength)
            return
        }
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
        self.getSwiftBranch()
    }
    
    func saveAmounts(originAmount: AmountRepresentable, destinationAmount: AmountRepresentable) {
        self.operativeData.amount = originAmount
        self.operativeData.receiveAmount = destinationAmount
        self.view?.setFloatingButtonEnabled(self.isFloatingButtonEnabled)
    }
    
    func didSelectIssueDate(_ date: Date) {
        self.operativeData.issueDate = date
        self.selectedIssueDate = date
    }
    
    func didSelecteOneFilterSegment(_ type: SendMoneyDateTypeViewModel) {
        self.operativeData.transferDateType = type
        guard type == .day && self.selectedIssueDate == nil else {
            return
        }
        let date = self.sendMoneyModifier?.selectionIssueDateViewModel.minDate
        self.selectedIssueDate = date
        self.operativeData.issueDate = date ?? Date()
    }
    
    func checkSimpleDate() {
        let originCurrency = self.operativeData.amount?.currencyRepresentable?.currencyCode
        let recivedCurrency = self.operativeData.receiveAmount?.currencyRepresentable?.currencyCode
        let isSameCurrency = originCurrency == recivedCurrency && originCurrency != getLocalCurrency()
        self.view?.setSimpleDate(!isSameCurrency)
    }
    
    func checkSwiftVew() {
        let recivedCurrency = self.operativeData.receiveAmount?.currencyRepresentable?.currencyCode == getLocalCurrency()
        let isLocalCountry = getLocalCode() == operativeData.countryCode
        self.view?.setHiddenSwiftView(recivedCurrency && isLocalCountry)
    }
}

extension SendMoneyAmountAllInternationalPresenter {
    var viewCurrencyHelper: SendMoneyCurrencyHelperViewProtocol? {
        return self.view
    }
}

extension SendMoneyAmountAllInternationalPresenter: AutomaticScreenTrackable {
    var trackerPage: SendMoneyAmountAndDatePage {
        SendMoneyAmountAndDatePage(national: self.operativeData.type == .national, type: self.operativeData.type.trackerName)
    }
    
    var trackerManager: TrackerManager {
        dependenciesResolver.resolve(for: TrackerManager.self)
    }
}
