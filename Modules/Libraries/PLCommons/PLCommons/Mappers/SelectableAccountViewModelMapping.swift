import PLUI

public protocol SelectableAccountViewModelMapping {
    func map(_ account: AccountForDebit, selectedAccountNumber: String?) throws -> SelectableAccountViewModel
}

public final class SelectableAccountViewModelMapper: SelectableAccountViewModelMapping {
    enum Error: Swift.Error {
        case accountNumberUncomplete
    }
    private let amountFormatter: NumberFormatter
    
    public init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    public func map(_ account: AccountForDebit, selectedAccountNumber: String?) throws -> SelectableAccountViewModel {
        amountFormatter.currencySymbol = account.availableFunds.currency
        let availableFundsText = amountFormatter.string(for: account.availableFunds.amount)
            ?? "\(account.availableFunds.amount) \(account.availableFunds.currency)"
        
        return SelectableAccountViewModel(
            name: account.name,
            accountNumber: try formatAccountNumber(account.number),
            accountNumberUnformatted: account.number,
            availableFunds: availableFundsText,
            isSelected: account.number == selectedAccountNumber
        )
    }
    
    private func formatAccountNumber(_ accountNumber: String) throws -> String {
        guard let last4Digits = accountNumber.substring(ofLast: 4) else {
            throw Error.accountNumberUncomplete
        }
        
        return "*" + last4Digits
    }
}
