import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusSMETransfer

final class ZusSmeTransferSummaryMapperTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)?
    private var SUT: ZusSmeTransferSummaryMapping?
    private var confirmationTransferDTO: ConfirmationTransferDTO?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        confirmationTransferDTO = ConfirmationTransferDTOMock.getMock()
        setUpDependencies()
        SUT = dependencies?.resolve(for: ZusSmeTransferSummaryMapping.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        confirmationTransferDTO = nil
    }
    
    func test_maping_dto_to_ZusSmeTransferSummaryModel() throws {
        let SUT = try XCTUnwrap(SUT)
        let confirmationTransferDTO = try XCTUnwrap(confirmationTransferDTO)
        let model = SUT.map(
            with: confirmationTransferDTO,
            transferModel: ZusSmeTransferModel.stub()
        )
        XCTAssertEqual(model.amount, 1500)
        XCTAssertEqual(model.currency, .złoty)
        XCTAssertEqual(model.transferType, .ZUS)
        XCTAssertEqual(model.accountVat?.number, "05109013620000000136623331")
        XCTAssertEqual(model.accountName, "GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA")
        XCTAssertEqual(model.accountNumber, "26109000880000000142230553")
        XCTAssertEqual(model.dateString, "30.11.2021")
    }
}

private extension ZusSmeTransferSummaryMapperTests {
    func setUpDependencies() {
        dependencies?.register(for: ZusSmeTransferSummaryMapping.self) { resolver in
            ZusSmeTransferSummaryMapper()
        }
    }
}
