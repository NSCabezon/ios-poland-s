import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import CharityTransfer

class CharityTransferValidatorTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: CharityTransferValidator!
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: CharityTransferValidator.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
    }
    
    func test_form_validation_with_too_much_amount() throws {
        let model = CharityTransferFormViewModel(amount: 100001,
                                                 date: Date(),
                                                 recipientAccountNumberUnformatted: "12123412341234123412341234")
        let validationMessages = SUT.validateForm(form: model)
        XCTAssertNotNil(validationMessages.tooMuchAmount)
        XCTAssertNil(validationMessages.tooLowAmount)
    }
    
    func test_form_validation_with_too_low_amount() throws {
        let model = CharityTransferFormViewModel(amount: 0,
                                                 date: Date(),
                                                 recipientAccountNumberUnformatted: "12123412341234123412341234")
        let validationMessages = SUT.validateForm(form: model)
        XCTAssertNotNil(validationMessages.tooLowAmount)
        XCTAssertNil(validationMessages.tooMuchAmount)
    }
    
    func test_form_validation_with_good_amount() throws {
        let model = CharityTransferFormViewModel(amount: 100,
                                                 date: Date(),
                                                 recipientAccountNumberUnformatted: "12123412341234123412341234")
        let validationMessages = SUT.validateForm(form: model)
        XCTAssertNil(validationMessages.tooLowAmount)
        XCTAssertNil(validationMessages.tooMuchAmount)
    }
}

private extension CharityTransferValidatorTests {
    func setUpDependencies() {
        dependencies.register(for: CharityTransferValidator.self) { resolver in
            CharityTransferValidator()
        }
    }
}
