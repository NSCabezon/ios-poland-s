//
//  DataLoaderCoordinatorTests.swift
//  PhoneTopUp_Tests
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

class DataLoaderCoordinatorTests: XCTestCase {
    
    var mockDependenciesResolver: DependenciesDefault!
    var mockNavigationController: UINavigationController!
    let mockMenuController = MockMenuViewController()
    var coordinator: TopUpDataLoaderCoordinator!
    
    override func setUp() {
        mockDependenciesResolver = DependenciesDefault.mockInstance()
        mockNavigationController = MockNavigationController(rootViewController: mockMenuController)

        coordinator = TopUpDataLoaderCoordinator(dependenciesResolver: mockDependenciesResolver, navigationController: mockNavigationController, settings: [])
    }
    
    func testNotShowingDataLoaderControllerBeforeStart() throws {
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }

    func testShowingDataLoaderControllerOnStart() throws {
        coordinator.start()
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be two controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is TopUpDataLoaderViewController, "The top controller should be an instance of TopUpDataLoaderViewController")
    }
    
    func testDismissingDataLoaderControllerOnClose() throws {
        coordinator.start()
        coordinator.close()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testShowingAccountSelectionWhenThereAreNoDefaultAccounts() throws {
        let account = AccountForDebit.mockInstance(defaultForPayments: false)
        coordinator.start()
        coordinator.showForm(with: TopUpPreloadedFormData(accounts: [account], operators: [], internetContacts: [], settings: [], topUpAccount: TopUpAccount.mockInstance()))
        
        XCTAssert(mockNavigationController.viewControllers.count == 3, "There should be 3 controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is AccountSelectorViewController, "The top controller should be an instance of AccountSelectorViewController")
    }
    
    func testShowingFormController() throws {
        let account = AccountForDebit.mockInstance(defaultForPayments: true)
        coordinator.start()
        coordinator.showForm(with: TopUpPreloadedFormData(accounts: [account], operators: [], internetContacts: [], settings: [], topUpAccount: TopUpAccount.mockInstance()))
        
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be 2 controllers on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of PhoneTopUpFormViewController")
    }
}
