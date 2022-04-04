import SANPLLibrary

struct PopularAccountMock {
    static var popularAccounts: [PopularAccountDTO] {
        let jsonData = """
        [
            {
                "number":"__60000002026_____________",
                "type":80,
                "currencyCode":"PLN",
                "branchCode":"60000002",
                "name":"ZAKLAD UBEZPIECZEN SPOLECZNYCH",
                "address":{},
                "transactionTitle":"ZAKLAD UBEZPIECZEN SPOLECZNYCH",
                "transferType":"ZUS",
                "validFrom":"2020-12-15",
                "options":7,"timestamp":1608043871,
                "typeName":"ZUS",
                "typeOptions":-2147475452,
                "drTransactionMask":0,
                "crTransactionMask":1073741828
            }
        ]
        """.data(using: .utf8)!
        return try! JSONDecoder().decode([PopularAccountDTO].self, from: jsonData)
    }
}
