import PLCommons
import SANPLLibrary
import CoreFoundationLib
@testable import SplitPayment

struct RecipientsMockBuilder {
    
    static func getPayeeListDtoMock() -> [PayeeDTO]? {
        guard let jsonData = """
        [{
        "payeeId":{
            "contractType":"ACCOUNT",
            "id":"1000"
            },
        "alias":"SplitPayment",
        "stamp":953319531,
        "account":{
                "accountType":{
                "code":90
                },
            "currencyCode":"PLN",
            "accountNo":"PL02600000020260006109165886",
            "payeeName":"SplitPayment",
            "branchInfo":{
                "branchCode":"60000002"
                },
            "transferType":"ELIXIR"
            }
        }]
        """.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([PayeeDTO].self, from: jsonData)
    }
}
