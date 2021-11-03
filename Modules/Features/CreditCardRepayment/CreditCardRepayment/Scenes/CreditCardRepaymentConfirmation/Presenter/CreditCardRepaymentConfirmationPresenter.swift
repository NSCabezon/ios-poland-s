//
//  CreditCardRepaymentConfirmationPresenter.swift
//  CreditCardRepayment
//
//  Created by 186484 on 08/07/2021.
//

import Operative
import Commons
import Models
import UI

protocol CreditCardRepaymentConfirmationPresenterProtocol: OperativeConfirmationPresenterProtocol {
    var view: CreditCardRepaymentConfirmationViewProtocol? { get set }
    func viewDidLoad()
    func didConfirmClosing()
}

class CreditCardRepaymentConfirmationPresenter {
    
    weak var view: CreditCardRepaymentConfirmationViewProtocol?
    let dependenciesResolver: DependenciesResolver
    var number: Int = 2
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = false
    var isCancelButtonEnabled: Bool = false
    
    var items: [ConfirmationItemViewModel] = []
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
    
    private lazy var sendCreditCardRepaymentUseCase: SendCreditCardRepaymentUseCase =
        dependenciesResolver.resolve(for: SendCreditCardRepaymentUseCase.self)
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension CreditCardRepaymentConfirmationPresenter: CreditCardRepaymentConfirmationPresenterProtocol {
    
    func viewDidLoad() {
        setUpView(with: formManager.form)
        view?.setContinueTitle(localized("generic_button_confirm"))
    }
    
    private func setUpView(with form: CreditCardRepaymentForm) {
        addAmount()
        addOriginAccount()
        addBankingNumber()
        addCreditCardRepName()
        addRepaymentType()
        addDate()
        addConfirmationItems()
    }
    
    private func addConfirmationItems() {
        view?.add(items)
        guard let totalViewModel = createTotalViewModel() else { return }
        view?.add(totalViewModel)
    }
    
    
    func didSelectContinue() {
        let input = SendCreditCardRepaymentUseCaseInput(form: formManager.form)
        view?.showLoading()
        Scenario(useCase: sendCreditCardRepaymentUseCase, input: input)
            .execute(on: dependenciesResolver.resolve())
            .onSuccess { [weak self] output in
                guard let self = self else { return }
                self.view?.dismissLoading() {
                    self.formManager.setSummary(output.summary)
                    self.container?.stepFinished(presenter: self)
                }
            }
            .onError { [weak self] _ in
                guard let self = self else { return }
                self.view?.dismissLoading() {
                    self.view?.showErrorDialog()
                }
            }
    }
    
    func didConfirmClosing() {
       container?.dismissOperative()
    }
    
}

private extension CreditCardRepaymentConfirmationPresenter {
    
    func addAmount() {
        guard let amount = formManager.form.amount else { return }
        let moneyDecorator = MoneyDecorator(amount, font: .santander(family: .text, type: .bold, size: 32), decimalFontSize: 18)
        let item = ConfirmationItemViewModel(
            title: localized("pl_creditCard_label_repAmount"),
            value: moneyDecorator.getFormatedAbsWith1M() ?? NSAttributedString(string: amount.getStringValue()),
            position: .first)
        items.append(item)
    }
    
    func addOriginAccount() {
        guard let originAccount = formManager.form.account else { return }
        let alias = originAccount.alias
        let availableAmount = originAccount.availableAmount.getStringValue()
        let title: LocalizedStylableText = localized("pl_creditCard_label_repSourceAccount")
        let item = ConfirmationItemViewModel(
            title: title,
            value: boldRegularAttributedString(bold: alias, regular: availableAmount)
        )
        items.append(item)
    }
    
    func addBankingNumber() {
        guard let bunkingNumber = formManager.form.account?.getDetailUI else { return }
        let title: LocalizedStylableText = localized("pl_creditCard_label_repSourceAccountNumb")
        let attributes = [NSAttributedString.Key.font: UIFont.santander(family: .headline, type: .bold, size: 16.0)]
        let attrBunkingNumber = NSAttributedString(string: bunkingNumber, attributes: attributes)
        let item = ConfirmationItemViewModel(
            title: title,
            value: attrBunkingNumber
        )
        items.append(item)
    }
    
    func addCreditCardRepName() {
        guard let creditCard = formManager.form.creditCard else { return }
        let cardNumber = "*" + creditCard.displayPan.suffix(4)
        let title: LocalizedStylableText = localized("pl_creditCard_label_cardRep")
        let cardNameAttributes = [NSAttributedString.Key.font: UIFont.santander(family: .headline, type: .bold, size: 16.0)]
        let cardNameAttrString = NSAttributedString(string: creditCard.alias, attributes: cardNameAttributes)
        let cardNumberTttributes = [NSAttributedString.Key.font: UIFont.santander(family: .micro, type: .bold, size: 16.0)]
        let cardNumberAttrString = NSAttributedString(string: cardNumber, attributes: cardNumberTttributes)
        
        let item = ConfirmationItemViewModel(
            title: title,
            value: cardNameAttrString,
            info: cardNumberAttrString
        )
        items.append(item)
    }
    
    func addRepaymentType() {
        guard let amount = formManager.form.amount else { return }
        let title: LocalizedStylableText = localized("pl_creditCard_title_repType")
        let font = UIFont.santander(family: .headline, type: .bold, size: 16.0)
        let repaymentTypeStr = NSMutableAttributedString(string: "\(formManager.form.repaymentType.localized) ", attributes: [NSAttributedString.Key.font: font])
        let moneyDecorator = MoneyDecorator(amount, font: font)
        let amountTmp = moneyDecorator.getCurrencyWithoutFormat() ?? NSAttributedString(string: "")
        let repaymentAmount = NSAttributedString(string: "(\(amountTmp.string))", attributes: [NSAttributedString.Key.font: font])
        repaymentTypeStr.append(repaymentAmount)
        let item = ConfirmationItemViewModel(
            title: title,
            value: repaymentTypeStr
        )
        items.append(item)
    }
    
    func addDate() {
        let dateString = formManager.form.date.toString(format: "dd.MM.YYYY")
        let attributes = [NSAttributedString.Key.font: UIFont.santander(family: .headline, type: .bold, size: 16.0)]
        let dateAttrString = NSAttributedString(string: dateString, attributes: attributes)
        let item = ConfirmationItemViewModel(
            title: localized("pl_creditCard_label_repDate"),
            value: dateAttrString,
            position: .last
        )
        items.append(item)
    }
    
    func createTotalViewModel() -> ConfirmationTotalOperationItemViewModel? {
        guard let amount = formManager.form.amount else { return nil }
        return ConfirmationTotalOperationItemViewModel(amountEntity: amount, type: .customKey("pl_creditCard_label_sum"))
    }
    
    /// Returns a string with the following format: `bold (regular)`
    /// - Parameters:
    ///   - bold: The bold part of the string
    ///   - regular: The regular part of the string
    private func boldRegularAttributedString(bold: String, regular: String) -> NSAttributedString {
        let regularWithParenthesis = "(" + regular + ")"
        let builder = TextStylizer.Builder(fullText: bold + " " + regularWithParenthesis)
        let boldStyle = TextStylizer.Builder.TextStyle(word: bold)
        let regularStyle = TextStylizer.Builder.TextStyle(word: regularWithParenthesis)
        return builder.addPartStyle(part: boldStyle
            .setColor(.lisboaGray)
            .setStyle(.santander(family: .micro, type: .bold, size: 16))
        ).addPartStyle(part: regularStyle
            .setColor(.lisboaGray)
            .setStyle(.santander(family: .micro, size: 16))
        ).build()
    }
}

extension CreditCardRepaymentConfirmationPresenter: AutomaticScreenActionTrackable {
    var trackerPage: CreditCardRepaymentConfirmationPage {
        CreditCardRepaymentConfirmationPage()
    }
    
    var trackerManager: TrackerManager {
        dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

// TODO:
// Change it in future
public struct CreditCardRepaymentConfirmationPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }

    public init() {}
}
