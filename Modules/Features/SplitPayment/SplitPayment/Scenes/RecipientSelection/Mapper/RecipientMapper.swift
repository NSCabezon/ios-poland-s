import SANPLLibrary
import CoreFoundationLib
import PLCommons

protocol RecipientMapping {
    func map(with confirmationTransferDto: [PayeeDTO]) -> [Recipient]
}

final class RecipientMapper: RecipientMapping {
    
    func map(with payeeListDto: [PayeeDTO]) -> [Recipient] {
        return payeeListDto.compactMap {
            Recipient(
                name: $0.payeeDisplayName ?? "",
                accountNumber: $0.account?.accountNo ?? ""
            )
        }
    }
}
