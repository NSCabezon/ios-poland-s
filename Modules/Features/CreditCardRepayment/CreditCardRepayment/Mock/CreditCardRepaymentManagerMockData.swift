import UIKit
import SANLegacyLibrary
import CoreFoundationLib
import UI
import SANPLLibrary

public final class CreditCardRepaymentManagerMockData {
    
    private let multipleChoices: Bool
    
    public init(multipleChoices: Bool) {
        self.multipleChoices = multipleChoices
    }
        
    public var ccrAccountsForDebit: [CCRAccountDTO] {
        let jsonData = """
            [
                {
                    "number":"45109014894000000121577326",
                    "id":"142367733",
                    "currencyCode":"PLN",
                    "name":{
                        "source":"Konto Private Banking",
                        "description":"Konto Private Banking",
                        "userDefined":""
                    },
                    "type":"PERSONAL",
                    "balance":{
                        "value":109.10,
                        "currencyCode":"PLN"
                    },
                    "availableFunds":{
                        "value":109.10,
                        "currencyCode":"PLN"
                    },
                    "lastUpdate":"2021-08-25",
                    "systemId":3,
                    "defaultForPayments":false,
                    "role":"OWNER",
                    "accountDetails":{
                        "interestRateIndicator":"VALUE",
                        "accountType":-101,
                        "sequenceNumber":1
                    }
                },
                {
                    "number":"63109014894000000121600961",
                    "id":"142367779",
                    "currencyCode":"PLN",
                    "name":{
                        "source":"Konto Jakie Chcę",
                        "description":"Konto Jakie Chcę",
                        "userDefined":""
                    },
                    "type":"PERSONAL",
                    "balance":{
                        "value":109391.64,
                        "currencyCode":"PLN"
                    },
                    "availableFunds":{
                        "value":109391.64,
                        "currencyCode":"PLN"
                    },
                    "lastUpdate":"2021-08-26",
                    "systemId":3,
                    "defaultForPayments":true,
                    "role":"OWNER",
                    "accountDetails":{
                        "interestRateIndicator":"VALUE",
                        "accountType":-101,
                        "sequenceNumber":2
                    }
                }
            ]
        """.data(using: .utf8)!
        let accounts = try! JSONDecoder().decode([CCRAccountDTO].self, from: jsonData)
        
        return multipleChoices ? accounts : accounts.dropLast(1)
    }
    
    public var ccrAccountsForCredit: [CCRAccountDTO] {
        let jsonData = """
            [
                {
                    "number":"45109014894000000121577326",
                    "id":"3053755",
                    "currencyCode":"PLN",
                    "name":{
                        "source":"MasterCardSilver",
                        "description":"MasterCardSilver",
                        "userDefined":""
                    },
                    "type":"CREDIT_CARD",
                    "balance":{
                        "value":30.83,
                        "currencyCode":"PLN"
                    },
                    "availableFunds":{
                        "value":6605.37,
                        "currencyCode":"PLN"
                    },
                    "systemId":2,
                    "defaultForPayments":false,
                    "role":"OWNER",
                    "accountDetails":{
                        "interestRateIndicator":"VALUE",
                        "accountType":214,
                        "sequenceNumber":3
                    },
                    "creditCardAccountDetails":{
                        "paymentDate":"2021-04-01",
                        "totalPaymentAmount":{
                            "value":-185.25,
                            "currencyCode":"PLN"
                        },
                        "minimalPaymentAmount":{
                            "value":-53.05,
                            "currencyCode":"PLN"
                        }
                    }
                },
                {
                    "number":"63109014894000000121600961",
                    "id":"3091341",
                    "currencyCode":"PLN",
                    "name":{
                        "source":"MasterCard World Elite",
                        "description":"MasterCard World Elite",
                        "userDefined":""
                    },
                    "type":"CREDIT_CARD",
                    "balance":{
                        "value":-1044.00,
                        "currencyCode":"PLN"
                    },
                    "availableFunds":{
                        "value":8956.00,
                        "currencyCode":"PLN"
                    },
                    "systemId":2,
                    "defaultForPayments":false,
                    "role":"OWNER",
                    "accountDetails":{
                        "interestRateIndicator":"VALUE",
                        "accountType":277,
                        "sequenceNumber":4
                    },
                    "creditCardAccountDetails":{
                        "totalPaymentAmount":{
                            "value":300.00,
                            "currencyCode":"PLN"
                        },
                        "minimalPaymentAmount":{
                            "value":150.00,
                            "currencyCode":"PLN"
                        }
                    }
                },
                {
                    "number":"45109014894000000121577326",
                    "id":"3091337",
                    "currencyCode":"PLN",
                    "name":{
                        "source":"Visa Silver AP",
                        "description":"Visa Silver Akcja Pajacyk",
                        "userDefined":""
                    },
                    "type":"CREDIT_CARD",
                    "balance":{
                        "value":0.00,
                        "currencyCode":"PLN"
                    },
                    "availableFunds":{
                        "value":4500.00,
                        "currencyCode":"PLN"
                    },
                    "systemId":2,
                    "defaultForPayments":true,
                    "role":"OWNER",
                    "accountDetails":{
                        "interestRateIndicator":"VALUE",
                        "accountType":218,
                        "sequenceNumber":5
                    },
                    "creditCardAccountDetails":{
                        "totalPaymentAmount":{
                            "value":0.00,
                            "currencyCode":"PLN"
                        },
                        "minimalPaymentAmount":{
                            "value":0.00,
                            "currencyCode":"PLN"
                        }
                    }
                    
                }
            ]
        """.data(using: .utf8)!
        let accounts = try! JSONDecoder().decode([CCRAccountDTO].self, from: jsonData)
        
        return multipleChoices ? accounts : accounts.dropLast(1)
    }
    
    public var globalPosition: SANPLLibrary.GlobalPositionDTO {
        let secondCard = """
                    {
                        "maskedPan": "545250_8846",
                        "virtualPan": "545250P005094962",
                        "generalStatus": "ACTIVE",
                        "cardStatus": "00",
                        "role": "OWNER",
                        "type": "CREDIT",
                        "productCode": "CCMB",
                        "name": {
                            "description": "Karta kredytowa 123",
                            "userDefined": "Karta kredytowa 123"
                        },
                        "relatedAccount": "45109014894000000121577326",
                        "expirationDate": "2023-04-30",
                        "availableBalance": {
                            "value": 5200.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 5200.00
                        },
                        "creditLimit": {
                            "value": 2500.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 2500.00
                        },
                        "disposedAmount": {
                            "value": 0.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 0.00
                        }
                    }
                """
        
        let jsonData = """
            {
                "cards": [
                    {
                        "maskedPan": "545250_5713",
                        "virtualPan": "545250P038230083",
                        "generalStatus": "ACTIVE",
                        "cardStatus": "00",
                        "role": "OWNER",
                        "type": "CREDIT",
                        "productCode": "MKKS",
                        "name": {
                            "description": "MasterCard Silver",
                            "userDefined": "MasterCard Silver"
                        },
                        "relatedAccount": "63109014894000000121600961",
                        "expirationDate": "2025-06-30",
                        "availableBalance": {
                            "value": 5200.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 5200.00
                        },
                        "creditLimit": {
                            "value": 2500.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 2500.00
                        },
                        "disposedAmount": {
                            "value": 0.00,
                            "currencyCode": "PLN",
                            "valueInBaseCurrency": 0.00
                        }
                    },
                    \(multipleChoices ? secondCard : "")
                ]
            }
        """.data(using: .utf8)!
        let globalPositionDTO = try! JSONDecoder().decode(SANPLLibrary.GlobalPositionDTO.self, from: jsonData)
        
        return globalPositionDTO
    }
    
    public var ccrSummaryDTO: AcceptDomesticTransferSummaryDTO {
        let jsonData = """
            {
              "debitAmountData": {
                "currency": "PLN",
                "amount": 1234
              },
              "debitAccountData": {
                "accountType": 1,
                "accountSequenceNumber": 101,
                "accountNo": "45109014894000000121577326"
              },
              "creditAccountData": {
                "accountType": 1,
                "accountSequenceNumber": 101,
                "accountNo": "63109014894000000121600961"
              },
              "title": "Some test title",
              "type": "OWN_TRANSACTION",
              "state": "ACCEPTED",
            }
        """.data(using: .utf8)!
        return try! JSONDecoder().decode(AcceptDomesticTransferSummaryDTO.self, from: jsonData)
    }
}
