import XCTest
@testable import ZusTransfer
import CoreFoundationLib
import PLCommons
import PLUI

final class ZusTransferFormPresenterTests: XCTestCase {
    private var sut: (ZusTransferFormPresenterProtocol & ZusTransferFormAccountSelectable)?
    private var dependencies: (DependenciesResolver & DependenciesInjector)?
    private var coordinator: ZusTransferFormCoordinatorMock?
    private var view: ZusTransferFormViewMock?

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        view = ZusTransferFormViewMock()
        setUpDependencies()
        sut = dependencies?.resolve(for: ZusTransferFormPresenter.self)
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
        sut.updateTransferFormViewModel(with: ZusTransferFormViewModelMockBuilder.getZusTransferFormViewModel())
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
            with: ZusTransferFormViewModelMockBuilder.getZusTransferFormViewModel()
        )
        sut.startValidation(with: .title)
        TestHelper.delay {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_recipient_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusTransferFormViewModelMockBuilder.getZusTransferFormViewModel()
        )
        sut.startValidation(with: .recipient)
        TestHelper.delay {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_amount_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusTransferFormViewModelMockBuilder.getZusTransferFormViewModel()
        )
        sut.startValidation(with: .amount)
        TestHelper.delay {
            XCTAssertTrue(view.showValidationMessagesCalled)
        }
    }
    
    func test_showValidationMessages_called_when_validation_accountNumber_is_performing() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.showValidationMessagesCalled)
        sut.updateTransferFormViewModel(
            with: ZusTransferFormViewModelMockBuilder.getZusTransferFormViewModel()
        )
        sut.startValidation(with: .accountNumber(controlEvent: .endEditing))
        TestHelper.delay {
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
                accountNumber: "82600000020260017772273629",
                transactionTitle: "Przelew ZUS"
            )
        )
        XCTAssertTrue(view.updateRecipientCalled)
    }
    
    func test_clearForm_called_should_start_clearForm_on_view() throws {
        let sut = try XCTUnwrap(sut)
        let view = try XCTUnwrap(view)
        sut.view = view
        XCTAssertFalse(view.clearFormCalled)
        sut.clearForm()
        TestHelper.delay {
            XCTAssertTrue(view.clearFormCalled)
        }
    }
}

private extension ZusTransferFormPresenterTests {
    func setUpDependencies() {
        dependencies?.register(for: ZusTransferFormCoordinatorProtocol.self) { [unowned self] _ in
            let mockCoordinator = ZusTransferFormCoordinatorMock()
            self.coordinator = mockCoordinator
            return mockCoordinator
        }
        dependencies?.register(for: ZusTransferFormViewProtocol.self) { _ in
            ZusTransferFormViewMock()
        }
        
        dependencies?.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        
        dependencies?.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        
        dependencies?.register(for: BankingUtilsProtocol.self) { resolver in
            BankingUtils(dependencies: resolver)
        }
        
        dependencies?.register(for: ZusTransferValidating.self) { resolver in
            ZusTransferValidator(dependenciesResolver: resolver)
        }
        
        dependencies?.register(for: ZusTransferFormPresenter.self) { resolver in
            ZusTransferFormPresenter(
                dependenciesResolver: resolver,
                accounts: AccountForDebitMockBuilder.getAccountForDebitMock(),
                selectedAccountNumber: "12123412341234123412341234"
            )
        }
    }
}
