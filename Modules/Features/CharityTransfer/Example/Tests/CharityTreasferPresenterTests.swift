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

class CharityTreasferPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: CharityTransferFormPresenterProtocol!
    private var coordinator: CharityTransferFormCoordinatorMock?

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: CharityTransferFormPresenterProtocol.self)
        coordinator = dependencies.resolve(for: CharityTransferFormCoordinatorProtocol.self) as? CharityTransferFormCoordinatorMock
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
    }
    
    func test_showAccountSelector_is_called() {
        SUT.showAccountSelector()
        TestHelper.delay { [unowned self] in
            XCTAssertTrue(self.coordinator?.showAccountSelectorCalled == true)
        }
    }
    
    func test_showConfirmation_is_called() {
        SUT.confirmTransfer()
        TestHelper.delay { [unowned self] in
            XCTAssertTrue(self.coordinator?.showConfirmationCalled == true)
        }
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
        XCTAssertEqual(viewModel.availableFunds, "1 500,00 PLN")
        XCTAssertEqual(viewModel.name, "Konto Jakie Chcesz")
        XCTAssertEqual(viewModel.isSelected, true)
    }
    
    func test_getting_selected_account_number() {
        let selectedAccountNumber = SUT.getSelectedAccountNumber()
        XCTAssertEqual(selectedAccountNumber, "12123412341234123412341234")
    }
    
    func test_goBack_called_should_start_closeProcess_coordinator_function() throws {
        SUT.didSelectCloseProcess()
        TestHelper.delay { [unowned self] in
            XCTAssertTrue(self.coordinator?.closeProcessCalled == true)
        }
    }
    
    func test_goBack_called_should_start_pop_coordinator_function() throws {
        SUT.didSelectClose()
        TestHelper.delay { [unowned self] in
            XCTAssertTrue(self.coordinator?.popCalled == true)
        }
    }
}

private extension CharityTreasferPresenterTests {
    func setUpDependencies() {
        
        dependencies.register(for: CharityTransferFormPresenterProtocol.self) { resolver in
            let presenter = CharityTransferFormPresenter(dependenciesResolver: resolver,
                                                         accounts: AccountForDebitMockBuilder.getAccountForDebitMockMock(),
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
        
        dependencies.register(for: CharityTransferFormCoordinatorProtocol.self) { _ in
            CharityTransferFormCoordinatorMock()
        }
    }
}

