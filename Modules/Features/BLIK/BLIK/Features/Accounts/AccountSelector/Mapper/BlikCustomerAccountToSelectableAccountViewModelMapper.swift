
import PLCommons
import PLUI

protocol BlikCustomerAccountToSelectableAccountViewModelMapping {
    func map(accounts: [BlikCustomerAccount], selectedAccountNumber: String) -> [SelectableAccountViewModel]
}

final class BlikCustomerAccountToSelectableAccountViewModelMapper: BlikCustomerAccountToSelectableAccountViewModelMapping {
    
    private let amountFormatter: NumberFormatter
    
    public init(amountFormatter: NumberFormatter) {
        self.amountFormatter = amountFormatter
    }
    
    func map(accounts: [BlikCustomerAccount], selectedAccountNumber: String) -> [SelectableAccountViewModel] {
        return accounts.map( {
            let availableFundsText = amountFormatter.string(for: $0.availableFunds.amount)
                ?? "\($0.availableFunds.amount) \($0.availableFunds.currency)"
            return SelectableAccountViewModel(name: $0.name,
                                              accountNumber: formatAccountNumber($0.number),
                                              accountNumberUnformatted: $0.number,
                                              availableFunds: availableFundsText ,
                                              isSelected: $0.number == selectedAccountNumber)
        })
    }
    
    private func formatAccountNumber(_ accountNumber: String) -> String {
        let last4Digits = accountNumber.substring(ofLast: 4) ?? ""
        return "*" + last4Digits
    }
}
