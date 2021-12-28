import Commons
import CoreDomain
import PLCommons
import CoreFoundationLib
import SANPLLibrary
import XCTest
@testable import CharityTransfer

class CharityTransferSummaryMapperTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: CharityTransferSummaryMapping!
    @DecodeFile(name: "setConfirmationResponse",
                bundle: Bundle(for: PLTransfersManagerSuccessMock.self))
    private var confirmationTransferDTO: ConfirmationTransferDTO
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: CharityTransferSummaryMapping.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
    }
    
    func test_maping_dto_to_charityTransferSummaryModel() throws {
        let model = SUT.map(with: confirmationTransferDTO)
        XCTAssertEqual(model.amount, 1)
        XCTAssertEqual(model.currency, .złoty)
        XCTAssertEqual(model.transferType, .INTERNAL)
        XCTAssertEqual(model.accountName, "GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA")
        XCTAssertEqual(model.accountNumber, "26 1090 0088 0000 0001 4223 0553")
        XCTAssertEqual(model.dateString, "30.11.2021")
    }
}

private extension CharityTransferSummaryMapperTests {
    func setUpDependencies() {
        dependencies.register(for: CharityTransferSummaryMapping.self) { resolver in
            CharityTransferSummaryMapper()
        }
    }
}
