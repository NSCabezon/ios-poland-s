import PLCommons
import SANPLLibrary
import CoreFoundationLib
@testable import ZusSMETransfer

struct RecipientsBuilderMock {
    
    static func getPayeeListDtoMock() -> [PayeeDTO]? {
        guard let jsonData = """
        [{
        "payeeId":{
            "contractType":"ACCOUNT",
            "id":"1000"
            },
        "alias":"ZUS",
        "stamp":953319531,
        "account":{
                "accountType":{
                "code":90
                },
            "currencyCode":"PLN",
            "accountNo":"PL02600000020260006109165886",
            "payeeName":"ZUS",
            "branchInfo":{
                "branchCode":"60000002"
                },
            "transferType":"ELIXIR"
            }
        }]
        """.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([PayeeDTO].self, from: jsonData)
    }
    
    static func getRecipient() -> Recipient {
        Recipient(name: "ZUS", accountNumber: "02600000020260006109165886")
    }
}
