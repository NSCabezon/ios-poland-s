import Foundation
import SANPLLibrary
import CoreFoundationLib
import PLCommons

protocol VATAccountDetailsMapping {
    func map(with accountDetails: AccountDetailDTO) -> VATAccountDetails
}

final class VATAccountDetailsMapper: VATAccountDetailsMapping {
    
    func map(with accountDetails: AccountDetailDTO) -> VATAccountDetails {
        let accountName = (accountDetails.name?.userDefined?.isEmpty ?? true) ? accountDetails.name?.description : accountDetails.name?.userDefined
        return VATAccountDetails(number: accountDetails.number ?? "",
                                 name: accountName ?? "",
                                 availableFunds: Decimal(accountDetails.availableFunds?.value ?? 0), 
                                 currency: accountDetails.availableFunds?.currencyCode ?? "")
    }
}
