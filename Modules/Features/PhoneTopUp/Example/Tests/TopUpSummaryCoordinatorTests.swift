//
//  TopUpSummaryCoordinatorTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 09/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import PLUI
@testable import PhoneTopUp

class TopUpSummaryCoordinatorTests: XCTestCase {
    
    var mockDependenciesResolver: DependenciesDefault!
    var mockNavigationController: UINavigationController!
    var mockDataLoaderCoordinator: MockTopUpDataLoaderCoordinator!
    let mockMenuController = MockMenuViewController()
    let mockFormController = PhoneTopUpFormViewController(presenter: MockPhoneTopUpFormPresenterProtocol())
    var coordinator: TopUpSummaryCoordinator!

    override func setUpWithError() throws {
        mockDependenciesResolver = DependenciesDefault.mockInstance()
        mockNavigationController = MockNavigationController()
        mockDataLoaderCoordinator = MockTopUpDataLoaderCoordinator()
        mockNavigationController.viewControllers = [mockMenuController, mockFormController]
        coordinator = TopUpSummaryCoordinator(dependenciesResolver: mockDependenciesResolver,
                                              navigationController: mockNavigationController,
                                              summary: TopUpModel.mockInstance())
        registerDependencies()
    }
    
    func testNotShowingSummaryControllerBeforeStart() throws {
        XCTAssert(mockNavigationController.viewControllers.count == 2, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is PhoneTopUpFormViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testShowingSummaryControllerOnStart() throws {
        coordinator.start()
        
        XCTAssert(mockNavigationController.viewControllers.count == 3)
        XCTAssert(mockNavigationController.topViewController is TopUpSummaryViewController, "The top controller should be an instance of TopUpSummaryViewController")
    }
    
    func testDismissingSummaryControllerOnClose() throws {
        coordinator.start()
        coordinator.close()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testGoingToGlobalPosition() throws {
        coordinator.start()
        coordinator.goToGlobalPosition()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testMakingAnotherTopUp() throws {
        coordinator.start()
        coordinator.makeAnotherTopUp()
        
        XCTAssert(mockDataLoaderCoordinator.didStartNewTransfer, "New transfer should be started")
    }
}

private extension TopUpSummaryCoordinatorTests {
    func registerDependencies() {
        mockDependenciesResolver.register(for: TopUpDataLoaderCoordinatorProtocol.self) { resolver in
            return self.mockDataLoaderCoordinator
        }
    }
}
