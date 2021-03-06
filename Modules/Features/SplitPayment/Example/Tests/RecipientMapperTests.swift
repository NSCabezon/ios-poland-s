import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import SplitPayment

final class RecipientMapperTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: RecipientMapping?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: RecipientMapping.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
    }
    
    func test_maping_dto_to_charityTransferSummaryModel() throws {
        let payeeList = try XCTUnwrap(RecipientsMockBuilder.getPayeeListDtoMock())
        let SUT = try XCTUnwrap(SUT)
        let recipients = SUT.map(with: payeeList)
        XCTAssertTrue(!recipients.isEmpty)
        let recipient = try XCTUnwrap(recipients.first)
        XCTAssertEqual(recipient.name, "SplitPayment")
        XCTAssertEqual(recipient.accountNumber, "PL02600000020260006109165886")
    }
}

private extension RecipientMapperTests {
    func setUpDependencies() {
        dependencies.register(for: RecipientMapping.self) { _ in
            RecipientMapper()
        }
    }
}
