//
//  PhoneTopUpCoordinatorTests.swift
//  PhoneTopUp_Example
//
//  Created by 188216 on 08/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import PLUI
@testable import PhoneTopUp

class PhoneTopUpFormCoordinatorTests: XCTestCase {
    
    var mockDependenciesResolver: DependenciesDefault!
    var mockNavigationController: UINavigationController!
    let mockMenuController = MockMenuViewController()
    var coordinator: PhoneTopUpFormCoordinator!
    
    override func setUp() {
        mockDependenciesResolver = DependenciesDefault.mockInstance()
        mockNavigationController = MockNavigationController(rootViewController: mockMenuController)
        coordinator = PhoneTopUpFormCoordinator(dependenciesResolver: mockDependenciesResolver,
                                                navigationController: mockNavigationController,
                                                formData: TopUpPreloadedFormData.mockInstance())
    }
    
    func testNotShowingFormControllerBeforeStart() throws {
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testShowingFormControllerOnStart() throws {
        coordinator.start()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of PhoneTopUpFormViewController")
    }
    
    func testShowingInternetContacts() throws {
        coordinator.start()
        coordinator.showInternetContacts()
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is InternetContactsViewController, "The top controller should be an instance of InternetContactsViewController")
    }
    
    func testShowingPhoneContacts() throws {
        coordinator.start()
        coordinator.showPhoneContacts([])
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneContactsViewController, "The top controller should be an instance of PhoneContactsViewController")
    }
    
    func testShowingConfirmation() throws {
        coordinator.start()
        coordinator.showTopUpConfirmation(with: TopUpModel.mockInstance())
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is TopUpConfirmationViewController, "The top controller should be an instance of TopUpConfirmationViewController")
    }
    
    func testShowingAccountSelection() throws {
        coordinator.start()
        coordinator.didSelectChangeAccount(availableAccounts: [AccountForDebit.mockInstance(defaultForPayments: true)], selectedAccountNumber: "0")
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is AccountSelectorViewController, "The top controller should be an instance of AccountSelectorViewController")
    }
    
    func testShowingOperatorSelection() throws {
        coordinator.start()
        coordinator.showOperatorSelection(currentlySelectedOperatorId: 0)
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is OperatorSelectionViewController, "The top controller should be an instance of OperatorSelectionViewController")
    }
    
    func testDismissingMobileContactsSelectorWhenContactIsSelected() throws {
        coordinator.start()
        coordinator.showPhoneContacts([])
        coordinator.mobileContactsDidSelectContact(MobileContact.mockInstance())
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of PhoneTopUpFormViewController")
    }
    
    func testDismissingInternetContactsSelectorWhenContactIsSelected() throws {
        coordinator.start()
        coordinator.showInternetContacts()
        coordinator.mobileContactsDidSelectContact(MobileContact.mockInstance())
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of PhoneTopUpFormViewController")
    }
    
    func testDismissingOperatorSelectorWhenOperatorIsSelected() throws {
        coordinator.start()
        coordinator.showOperatorSelection(currentlySelectedOperatorId: 0)
        coordinator.didSelectOperator(Operator.mockInstance())
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of PhoneTopUpFormViewController")
    }
}
