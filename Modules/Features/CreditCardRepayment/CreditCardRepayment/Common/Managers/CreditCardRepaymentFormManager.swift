import Foundation
import CoreFoundationLib
import SANLegacyLibrary

typealias Currency = CurrencyDTO

class CreditCardRepaymentFormManager {
    
    private var subscribers: [Subscriber] = []
    
    private(set) var originalForm: CreditCardRepaymentForm
    private(set) var form: CreditCardRepaymentForm {
        didSet {
            notify()
        }
    }
    private(set) var steps: [CreditCardRepaymentStep]
    private(set) var accountSelectionPossible: Bool
    private(set) var currency: Currency // TODO: Not sure whether this should be here or in the from
    private(set) var summary: CreditCardRepaymentSummary?
    var chooseCardStepAvailable: Bool { steps.contains(.chooseCard) }
    var hasFormChanged: Bool { originalForm != form }
    
    init() {
        form = CreditCardRepaymentForm(creditCard: nil,
                                       account: nil,
                                       repaymentType: .minimal,
                                       amount: nil,
                                       date: Date())
        steps = []
        accountSelectionPossible = true
        currency = Currency(currencyName: "", currencyType: .other)
        summary = nil
        originalForm = form
    }
    
    func setCreditCard(_ creditCard: CCRCardEntity?) {
        form = form
            .replacing(creditCard: creditCard)
            .replacing(repaymentType: .minimal)
            .replacing(amount: creditCard?.minimalPaymentAmount)

        originalForm = form
    }
    
    func setAccount(_ account: CCRAccountEntity) {
        form = form.replacing(account: account)
    }
    
    func setRepaymentType(_ repaymentType: CreditCardRepaymentType, withAmount amount: AmountEntity?) {
        let newAmount = (repaymentType == .other && amount == nil) ? form.creditCard?.minimalPaymentAmount : amount
        form = form
            .replacing(repaymentType: repaymentType)
            .replacing(amount: newAmount)
    }
    
    func setAmount(amount: AmountEntity?) {
        form = form.replacing(amount: amount)
    }
    
    func setDate(date: Date) {
        form = form.replacing(date: date)
    }
    
    func setSummary(_ summary: CreditCardRepaymentSummary) {
        self.summary = summary
    }
    
    func reset() {
        form = originalForm
    }
    
    // MARK: - Subscribe methods
    
    func makeAndSubscribe(
        includeLastValue: Bool = true,
        onChanged: ((CreditCardRepaymentForm) -> Void)?
    ) -> Subscriber {
        let subscriber = Subscriber(manager: self)
        subscriber.onChanged = onChanged
        subscribers.append(subscriber)

        if includeLastValue {
            onChanged?(form)
        }
        return subscriber
    }

    func remove(subscriber: Subscriber) {
        guard let index = subscribers.firstIndex(where: { $0 === subscriber }) else {
            return
        }

        subscribers.remove(at: index)
    }
    
    private func notify() {
        subscribers.forEach({ $0.onChanged?(form) })
    }
}

extension CreditCardRepaymentFormManager {
    
    final class Subscriber {
        var onChanged: ((CreditCardRepaymentForm) -> Void)?
        private weak var manager: CreditCardRepaymentFormManager?

        fileprivate init(manager: CreditCardRepaymentFormManager) {
            self.manager = manager
        }

        func remove() {
            manager?.remove(subscriber: self)
        }
    }
}

extension CreditCardRepaymentFormManager: CustomStringConvertible {
    var description: String {
        get {
            "form: " + form.description + " steps: \(steps.count)"
        }
    }
}

extension CreditCardRepaymentFormManager {
    func initialSetup(
        form: CreditCardRepaymentForm,
        steps: [CreditCardRepaymentStep],
        accountSelectionPossible: Bool,
        currency: Currency
    ) {
        self.form = form
        self.steps = steps
        self.accountSelectionPossible = accountSelectionPossible
        self.currency = currency
        self.originalForm = form
    }
}
