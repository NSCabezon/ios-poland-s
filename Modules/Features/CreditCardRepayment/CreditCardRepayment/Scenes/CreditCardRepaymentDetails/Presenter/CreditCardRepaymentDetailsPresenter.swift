//
//  CreditCardRepaymentDetailsPresenter.swift
//  Pods
//
//  Created by 186490 on 01/06/2021.
//

import UI
import Models
import Commons
import Operative
import SANLegacyLibrary

protocol CreditCardRepaymentDetailsPresenterProtocol: OperativeStepPresenterProtocol, MenuTextWrapperProtocol {
    var view: CreditCardRepaymentDetailsViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func didConfirmClosing()
    func backButtonSelected()
}

final class CreditCardRepaymentDetailsPresenter {
    
    var number: Int = 1
    var container: OperativeContainerProtocol?
    var isBackButtonEnabled: Bool = true
    var isCancelButtonEnabled: Bool = true
    
    weak var view: CreditCardRepaymentDetailsViewProtocol?
    let dependenciesResolver: DependenciesResolver
    private var subscriber: CreditCardRepaymentFormManager.Subscriber?

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    private lazy var formManager: CreditCardRepaymentFormManager =
        dependenciesResolver.resolve(for: CreditCardRepaymentFormManager.self)
    
    lazy var accountChooseListCoordinator: AccountChooseListCoordinatorProtocol = {
        var coordinator = dependenciesResolver.resolve(for: AccountChooseListCoordinatorProtocol.self)
        coordinator.onCloseConfirmed = { [weak self] in
            self?.container?.dismissOperative()
        }
        return coordinator
    }()
    
    lazy var repaymentAmountOptionChooseListCoordinator: RepaymentAmountOptionChooseListCoordinatorProtocol = {
        var coordinator = dependenciesResolver.resolve(for: RepaymentAmountOptionChooseListCoordinatorProtocol.self)
        coordinator.onCloseConfirmed = { [weak self] in
            self?.container?.dismissOperative()
        }
        return coordinator
    }()
        
    deinit {
        subscriber?.remove()
    }
}

extension CreditCardRepaymentDetailsPresenter: CreditCardRepaymentDetailsPresenterProtocol {
    func viewDidLoad() {
        subscriber = formManager.makeAndSubscribe { [weak self] form in
            self?.reloadForm(form: form)
        }
    }
    
    func viewWillAppear() {
        // NOTE: There are problems with changing textfield text value when typing decimal separator, so this workaround is for initializing text only once
        setUpCreditCardRepaymentDetailsRepaymentAmountViewModel(form: formManager.form, initialText: formManager.form.amount?.value?.getDecimalFormattedValue())
        container?.progressBarAlpha(1.0)
    }
    
    func didConfirmClosing() {
        container?.dismissOperative()
    }
    
    func backButtonSelected() {
        goBackWithValidation()
    }
    
    private func reloadForm(form: CreditCardRepaymentForm) {
        view?.setupEditHeader(
            with: CreditCardRepaymentDetailsEditHeaderViewModel(
                title: localized("pl_creditCard_label_cardRep"),
                description: formManager.form.creditCard?.alias ?? "",
                isEditVisible: formManager.chooseCardStepAvailable,
                tapAction: { [weak self] in
                    self?.goBackWithValidation()
                }
            )
        )
        
        view?.setupAccountTypeInfo(
            with: CreditCardRepaymentDetailsAccountInfoViewModel(
                title: form.account?.alias ?? "",
                description: localized("pl_creditCard_label_repSourceAccount"),
                isEdgesVisible: formManager.accountSelectionPossible,
                tapAction: { [weak self] in
                    guard let self = self else { return }
                    if self.formManager.accountSelectionPossible {
                        self.goToAccountChooseListCoordinator()
                    }
                }
            )
        )
        
        view?.setupRepaymentTypeInfo(
            with: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel(
                title: form.repaymentTypeInfoTitle,
                description: localized("pl_creditCard_label_repType"),
                isEdgesVisible: true,
                tapAction: { [weak self] in
                    self?.goToRepaymentAmountOptionChooseListCoordinator()
                }
            )
        )
        
        setUpCreditCardRepaymentDetailsRepaymentAmountViewModel(form: form)
        
        view?.setupDateInfo(
            with: CreditCardRepaymentDateInfoViewModel(
                text: localized("pl_creditCard_label_repDate"),
                date: formManager.form.date,
                didEndEditing: { [weak self] date in
                    guard let self = self else { return }
                    // Fix for [TEET-154154]. We don't update the date if the dates are equal (both are on the same day).
                    guard !Calendar.current.isDate(self.formManager.form.date, inSameDayAs: date) else { return }
                    
                    self.formManager.setDate(date: date)
                }
            )
        )
        
        view?.setupNext(
            with: CreditCardRepaymentDetailsNextViewModel(
                tapAction: { [weak self] in
                    guard let self = self else { return }
                    if self.formManager.form.amount?.value == 0 {
                        self.showMinimumAmountAlert()
                    } else {
                        self.container?.stepFinished(presenter: self)
                    }
                },
                isEnabled: formManager.form.amount != nil
            )
        )
        
    }
    
    private func setUpCreditCardRepaymentDetailsRepaymentAmountViewModel(form: CreditCardRepaymentForm, initialText: String? = nil) {
        let canEditAmountViewModel = CreditCardRepaymentDetailsRepaymentAmountViewModel(
            initialText: initialText,
            placeholder: localized("pl_creditCard_label_repAmount"),
            currency: formManager.currency.currencyName,
            canEdit: form.repaymentType == .other,
            errorMessage: form.isAmountMissing ? localized("pl_creditCard_alert_repAmountEmptyText") : nil,
            didChange: { [weak self] value in
                guard let self = self else { return }
                if let decimalValue = Decimal(string: value) {
                    let amount = AmountDTO(value: decimalValue, currency: self.formManager.currency)
                    self.formManager.setAmount(amount: AmountEntity(amount))
                } else {
                    self.formManager.setAmount(amount: nil)
                }
            }
        )
        view?.setupRepaymentAmount(with: canEditAmountViewModel)
    }
    
    func showMinimumAmountAlert() {
        view?.showMinimumAmountDialog()
    }
}

// MARK: - Non Operative Navigation

private extension CreditCardRepaymentDetailsPresenter {
    
    func goToAccountChooseListCoordinator() {
        accountChooseListCoordinator.start()
        container?.progressBarAlpha(0.0)
    }
    
    func goToRepaymentAmountOptionChooseListCoordinator() {
        repaymentAmountOptionChooseListCoordinator.start()
        container?.progressBarAlpha(0.0)
    }
    
}

// MARK: - Back button methods

private extension CreditCardRepaymentDetailsPresenter {
    private func goBack() {
        if formManager.chooseCardStepAvailable {
            container?.back(to: CreditCardChooseListPresenter.self)
        } else {
            container?.dismissOperative()
        }
    }
    
    private func goBackWithValidation() {
        guard formManager.hasFormChanged else {
            goBack()
            return
        }
        self.view?.showConfirmAbandonChangesDialog(
            onAccept: { [weak self] in
                self?.subscriber?.remove()
                self?.goBack()
                self?.formManager.reset()
            }
        )
    }
}

// MARK: - Trackable

extension CreditCardRepaymentDetailsPresenter: AutomaticScreenActionTrackable {
    var trackerPage: CreditCardRepaymentDetailsPage {
        CreditCardRepaymentDetailsPage()
    }

    var trackerManager: TrackerManager {
        dependenciesResolver.resolve(for: TrackerManager.self)
    }
}

// TODO:
// Change it in future
public struct CreditCardRepaymentDetailsPage: PageWithActionTrackable {
    public typealias ActionType = Action
    public let page = "examplePage"
    
    public enum Action: String {
        case apply = "example"
    }

    public init() {}
}

private extension CreditCardRepaymentForm {
    var isAmountMissing: Bool {
        amount?.value?.description.isEmpty ?? true
    }
    
    var repaymentTypeInfoTitle: String {
        var title = repaymentType.localized
        // Show amount info only for complete and minimal type
        // Based on: [TEET-153537]
        if let displayValue = amount?.getFormattedDisplayValueAndCurrency(with: NumberFormatter.PLAmountNumberFormatterWithoutCurrency), repaymentType != .other {
            title += " (" + displayValue + ")"
        }
        return title
    }
}
