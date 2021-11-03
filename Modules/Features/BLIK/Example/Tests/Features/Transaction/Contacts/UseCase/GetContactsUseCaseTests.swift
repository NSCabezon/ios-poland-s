import Commons
@testable import BLIK
import DomainCommon
import SANPLLibrary
import XCTest

class GetContactsUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: GetContactsUseCase!

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        queue = DispatchQueue(label: "GetContactsUseCaseTests")
        SUT = dependencies.resolve(for: GetContactsUseCase.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }

    func test_get_contacts_use_case_success() throws {
        let scenario = Scenario(useCase: SUT)
            .execute(on: queue)
            
        queue.sync { }
        
        scenario.onSuccess { output in
            XCTAssertEqual(output.contacts.count, 2)
            XCTAssertEqual(output.contacts[0].fullName, "Johhny Appleased")
            XCTAssertEqual(output.contacts[0].phoneNumber, "123 456 789")
            XCTAssertEqual(output.contacts[1].fullName, "Johhny Appleased")
            XCTAssertEqual(output.contacts[1].phoneNumber, "987 654 321")
        }
        
        scenario.onError { _ in
            XCTFail()
        }
    }
}

private extension GetContactsUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetContactsUseCase.self) { resolver in
            GetContactsUseCase(contactStore: CNContactStoreMock(), contactMapper: ContactMapper())
        }
    }
}
