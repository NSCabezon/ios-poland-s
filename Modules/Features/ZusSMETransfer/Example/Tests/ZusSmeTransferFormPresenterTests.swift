import XCTest
@testable import ZusSMETransfer
import CoreFoundationLib
import PLCommons
import PLUI

final class ZusSmeTransferFormPresenterTests: XCTestCase {
    private var sut: (ZusSmeTransferFormPresenterProtocol & ZusSmeTransferFormAccountSelectable)?
    private var dependencies: (DependenciesResolver & DependenciesInjector)?
    private var coordinator: ZusSmeTransferFormCoordinatorMock?
    private var getVatAccountMockUseCase: GetVatAccountUseCaseStub?
    private var view: ZusSmeTransferFormViewMock?

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        view = ZusSmeTransferFormViewMock()
        setUpDependencies()
        sut = dependencies?.resolve(for: ZusSmeTransferFormPresenter.self)
    }
    
    override func tearDown() {
        sut = nil
        dependencies = nil
        coordinator = nil
        view = nil
        super.tearDown()
    }
    
    func test_showAccountSelector_is_called() throws {
        let sut = try XCTUnwrap(sut)
        sut.showAccountSelector()
        XCTAssert(coordinator?.showAccountSelectorCalled == true)
    }

    func test_showConfirmation_is_called() throws {
        let sut = try XCTUnwrap(sut)
        sut.updateTransferFormViewModel(with: ZusSmeTransferFormViewModelMockBuilder.getZusSmeTransferFormViewModel())
        sut.showConfirmation()
        XCTAssert(coordinator?.showConfirmationCalled == true)
    }
    
    func test_getting_selected_account_view_models() throws {
        let sut = try XCTUnwrap(sut)
        let viewModels = sut.getSelectedAccountViewModels()
        XCTAssertEqual(viewModels.count, 1)
        guard let viewModel = viewModels.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(viewModel.accountNumber, "*1234")
        XCTAssertEqual(viewModel.accountNumberUnformatted, "12123412341234123412341234")
        XCTAssertEqual(viewModel.availableFunds, "1 500,00 PLN")
        XCTAssertEqual(viewModel.name, "Konto Jakie Chcesz")
        XCTAssertEqual(viewModel.isSelected, true)
    }
    
    func test_getting_selected_account_number() throws {
        let sut = try XCTUnwrap(sut)
        let selectedAccountNumber = sut.getSelectedAccountViewModels().first?.accountNumberUnformatted
        XCTAssertEqual(selectedAccountNumber, "12123412341234123412341234")
    }
    
    func test_goClose_called_should_shoiw_dialog() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        sut.didSelectCloseProcess()
        XCTAssert(view.showDialogCalled)
    }

    func test_goBack_called_should_start_pop_coordinator_function() throws {
        let sut = try XCTUnwrap(sut)
        sut.didSelectClose()
        XCTAssert(coordinator?.popCalled == true)
    }
    
    func test_setAccountViewModel_called() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.setAccountViewModelCalled)
        sut.updateSelectedAccountNumber(number: "1212")
        XCTAssertTrue(view.setAccountViewModelCalled)
    }
    
    func test_showValidationMessages_called_when_validation_title_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusSmeTransferFormViewModelMockBuilder.getZusSmeTransferFormViewModel()
        )
        sut.startValidation(with: .title)
        delayedTests(2) {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_recipient_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusSmeTransferFormViewModelMockBuilder.getZusSmeTransferFormViewModel()
        )
        sut.startValidation(with: .recipient)
        delayedTests(2) {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_amount_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusSmeTransferFormViewModelMockBuilder.getZusSmeTransferFormViewModel()
        )
        sut.startValidation(with: .amount)
        delayedTests(2) {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_accountNumber_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusSmeTransferFormViewModelMockBuilder.getZusSmeTransferFormViewModel()
        )
        sut.startValidation(with: .accountNumber(controlEvent: .endEditing))
        delayedTests(2) {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showRecipientSelection_called_should_start_showRecipient_coordinator_function() throws {
        let sut = try XCTUnwrap(sut)
        sut.showRecipientSelection()
        XCTAssert(coordinator?.showRecipientSelectionCalled == true)
    }
    
    func test_didSelectRecipient_called_should_start_updateRecipientCalled_on_view() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.updateRecipientCalled)
        sut.didSelectRecipient(
            Recipient(
                name: "ZUS",
                accountNumber: "82600000020260017772273629"
            )
        )
        XCTAssertTrue(view.updateRecipientCalled)
    }
}

private extension ZusSmeTransferFormPresenterTests {
    func setUpDependencies() {
        dependencies?.register(for: ZusSmeTransferFormCoordinatorProtocol.self) { [unowned self] _ in
            let mockCoordinator = ZusSmeTransferFormCoordinatorMock()
            self.coordinator = mockCoordinator
            return mockCoordinator
        }
        dependencies?.register(for: ZusSmeTransferFormViewProtocol.self) { _ in
            ZusSmeTransferFormViewMock()
        }
        
        dependencies?.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        
        dependencies?.register(for: GetVATAccountUseCaseProtocol.self) { _ in
            let useCase = GetVatAccountUseCaseStub()
            self.getVatAccountMockUseCase = useCase
            return useCase
        }
        
        dependencies?.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler()
        }
        dependencies?.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        dependencies?.register(for: BankingUtilsProtocol.self) { resolver in
            BankingUtils(dependencies: resolver)
        }
        
        dependencies?.register(for: ZusSmeTransferValidating.self) { resolver in
            ZusSmeTransferValidator(dependenciesResolver: resolver)
        }
        
        dependencies?.register(for: ZusSmeTransferFormPresenter.self) { resolver in
            ZusSmeTransferFormPresenter(
                dependenciesResolver: resolver,
                accounts: AccountForDebitStubBuilder.stub(),
                selectedAccountNumber: "12123412341234123412341234"
            )
        }
    }
}
