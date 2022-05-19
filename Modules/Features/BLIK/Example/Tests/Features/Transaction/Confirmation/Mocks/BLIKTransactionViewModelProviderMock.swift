import CoreFoundationLib
import SANPLLibrary
@testable import BLIK

struct BLIKTransactionViewModelProviderMock: BLIKTransactionViewModelProviding {
    private let transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
   
    func getViewModel(_ completion: @escaping (Result<BLIKTransactionViewModel, Error>) -> ()) {
        completion(
            .success(
                BLIKTransactionViewModel(
                    transaction: transaction
                )
            )
        )
    }
}

extension Transaction {
    static func stub(
        transactionId: Int = 1,
        title: String = "",
        date: Date? = Date(),
        time: Date? = Date(),
        transferType: TransferType,
        aliasContext: AliasContext = .none,
        amount: Decimal = 1,
        merchant: GetTrnToConfDTO.Merchant? = nil,
        transactionRawValue: GetTrnToConfDTO
    ) -> Self {
        Transaction(
            transactionId: transactionId,
            title: title,
            date: date,
            time: time,
            transferType: transferType,
            aliasContext: aliasContext,
            amount: amount,
            merchant: merchant,
            transactionRawValue: transactionRawValue
        )
    }
}
