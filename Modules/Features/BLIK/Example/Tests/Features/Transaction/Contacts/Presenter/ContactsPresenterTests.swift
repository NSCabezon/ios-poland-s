import Commons
@testable import BLIK
import DomainCommon
import SANPLLibrary
import XCTest

class ContactsPresenterTests: XCTestCase {
    
    private var SUT: ContactsPresenterProtocol!
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var view: ContactsViewMock!
    fileprivate var queue: DispatchQueue!

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        queue = DispatchQueue(label: "ContactsPresenterTests")
        setUpDependencies()
        SUT = dependencies.resolve(for: ContactsPresenterProtocol.self)
        view = ContactsViewMock()
        SUT.view = view
    }
    
    override func tearDown() {
        super.tearDown()
        self.SUT = nil
        self.dependencies = nil
        view = nil
        queue = nil
    }
    
    func test_contacts_presenter_verify_contacts() {
        SUT.viewDidLoad()
        
        XCTAssertTrue(view.showLoaderCalled)
        queue.sync {}

        view.onSetupWithViewModel = { viewModels in
            XCTAssertEqual(viewModels.count, 1)
            let viewModel = viewModels[0]
            XCTAssertEqual(viewModel.letter, "J")
            XCTAssertEqual(viewModel.contacts.count, 2)
        }
    }
}

private extension ContactsPresenterTests {
    
    func setUpDependencies() {
    
        dependencies.register(for: ContactsPresenterProtocol.self) { resolver in
            ContactsPresenter(dependenciesResolver: resolver, selectableContactDelegate: nil)
        }

        dependencies.register(for: GetContactsUseCaseProtocol.self) { resolver in
            GetContactsUseCase(contactStore: CNContactStoreMock(), contactMapper: ContactMapper())
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PhoneVerificationProtocol.self) { resolver in
            PhoneVerificationUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager()
        }
    }
}
