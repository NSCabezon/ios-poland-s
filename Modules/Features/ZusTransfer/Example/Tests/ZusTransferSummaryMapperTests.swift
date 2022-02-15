import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusTransfer

class ZusTransferSummaryMapperTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: ZusTransferSummaryMapping!
    private var confirmationTransferDTO: ConfirmationTransferDTO!
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setConformation()
        setUpDependencies()
        SUT = dependencies.resolve(for: ZusTransferSummaryMapping.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        confirmationTransferDTO = nil
    }
    
    func test_maping_dto_to_charityTransferSummaryModel() throws {
        let model = SUT.map(with: confirmationTransferDTO)
        XCTAssertEqual(model.amount, 1500)
        XCTAssertEqual(model.currency, .złoty)
        XCTAssertEqual(model.transferType, .ZUS)
        XCTAssertEqual(model.accountName, "GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA")
        XCTAssertEqual(model.accountNumber, "26 1090 0088 0000 0001 4223 0553")
        XCTAssertEqual(model.dateString, "30.11.2021")
    }
}

private extension ZusTransferSummaryMapperTests {
    func setUpDependencies() {
        dependencies.register(for: ZusTransferSummaryMapping.self) { resolver in
            ZusTransferSummaryMapper()
        }
    }
    
    func setConformation() {
        let jsonData = """
        {
           "customerAddressData":{
              "customerName":"",
              "city":"",
              "street":"",
              "zipCode":"",
              "baseAddress":""
           },
           "debitAmountData":{
              "currency":"PLN",
              "amount":-1500.00,
              "currencyRate":"",
              "currencyUnit":0
           },
           "creditAmountData":{
              "currency":"PLN",
              "amount":1500.00,
              "currencyRate":"",
              "currencyUnit":0
           },
           "debitAccountData":{
              "accountType":101,
              "accountSequenceNumber":2,
              "branchId":"10900088",
              "accountNo":"26109000880000000142230553",
              "accountName":"GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA"
           },
           "creditAccountData":{
              "accountType":80,
              "accountSequenceNumber":0,
              "branchId":"10901362",
              "accountNo":"55600000020260001418988146",
              "accountName":"ZUS"
           },
           "transactionAmountData":{
              "baseAmount":-1500.00
           },
           "title":"Donation to the Santander Foundation",
           "type":"ZUS_TRANSACTION",
           "valueDate":"2021-11-30",
           "sendApplicationId":21,
           "timestamp":1629986452,
           "options":4,
           "dstPhoneNo":"",
           "ownerCifNumber":1014303930,
           "transactionSide":"TRN_NO_SIDE",
           "noFixedRate":0,
           "customerRef":"",
           "transferType":"ZUS",
           "key":{
              "id":445188,
              "date":"2021-11-30"
           },
           "signHistoryData":[
              {
                 "signLoginId":46425222,
                 "signResult":0,
                 "signTime":"2021-11-30T13:00:57.000",
                 "signTrnState":"ACCEPTED",
                 "signCifNumber":1014303930,
                 "signApplicationId":21
              }
           ],
           "state":"ACCEPTED",
           "sendError":0,
           "postingId":0,
           "acceptanceTime":"2021-11-30T13:00:57.000"
        }
        """.data(using: .utf8)!
        confirmationTransferDTO = try! JSONDecoder().decode(ConfirmationTransferDTO.self, from: jsonData)
    }
}
