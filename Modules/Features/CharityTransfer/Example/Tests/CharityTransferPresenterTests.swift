//
//  CharityTreasferPresenterTests.swift
//  CharityTransfer_Example
//
//  Created by 187125 on 14/12/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//
import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import CharityTransfer

final class CharityTransferPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: CharityTransferFormPresenterProtocol!
    private var coordinator: CharityTransferFormCoordinatorMock!
    private var view: CharityTransferFormViewMock?
    
    override func setUp() {
        super.setUp()
        coordinator = CharityTransferFormCoordinatorMock()
        view = CharityTransferFormViewMock()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: CharityTransferFormPresenterProtocol.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        coordinator = nil
        view = nil
    }
    
    func test_showAccountSelector_is_called() {
        SUT.showAccountSelector()
        XCTAssertTrue(coordinator.showAccountSelectorCalled)
    }
    
    func test_showConfirmation_is_called() throws {
        SUT.updateTransferFormViewModel(
            with: CharityTransferFormViewModelBuilderMock.getCharityTransferFormViewModel()
        )
        SUT.confirmTransfer()
        XCTAssertTrue(coordinator.showConfirmationCalled)
    }
    
    func test_getting_selected_account_view_models() {
        let viewModels = SUT.getSelectedAccountViewModels()
        XCTAssertEqual(viewModels.count, 1)
        guard let viewModel = viewModels.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(viewModel.accountNumber, "*1234")
        XCTAssertEqual(viewModel.accountNumberUnformatted, "12123412341234123412341234")
        XCTAssertEqual(viewModel.availableFunds, "1500.00 PLN")
        XCTAssertEqual(viewModel.name, "Konto Jakie Chcesz")
        XCTAssertEqual(viewModel.isSelected, true)
    }
    
    func test_getting_selected_account_number() {
        guard let selectedAccountViewModel = SUT.getSelectedAccountViewModels().first else {
            XCTFail()
            return
        }
        XCTAssertEqual(selectedAccountViewModel.accountNumberUnformatted, "12123412341234123412341234")
    }
    
    func test_didSelectCloseProcess_called_should_show_dialog() throws {
        let view = try XCTUnwrap(view)
        SUT.view = view
        SUT.didSelectCloseProcess()
        XCTAssertTrue(view.showDialogCalled)
    }
    
    func test_goBack_called_should_start_pop_coordinator_function() {
        SUT.didSelectClose()
        XCTAssertTrue(coordinator.popCalled)
    }
}

private extension CharityTransferPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: CharityTransferFormCoordinatorProtocol.self) { [unowned self] _ in
            self.coordinator
        }
        dependencies.register(for: CharityTransferFormPresenterProtocol.self) { resolver in
            let presenter = CharityTransferFormPresenter(dependenciesResolver: resolver,
                                                         accounts: [AccountForDebit.stub()],
                                                         selectedAccountNumber: "12123412341234123412341234",
                                                         formValidator: CharityTransferValidator(),
                                                         charityTransferSettings: CharityTransferSettings(
                                                            transferRecipientName: "Fundacja Santander",
                                                            transferAccountNumber: "26 1090 0088 0000 0001 4223 0553",
                                                            transferTitle: "Darowizna dla Fundacji Santander"
                                                         )
            )
            return presenter
        }
    }
}

