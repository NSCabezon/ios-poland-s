//
//  TopUpConfirmationCoordinatorTests.swift
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

class TopUpConfirmationCoordinatorTests: XCTestCase {
    var mockDependenciesResolver: DependenciesDefault!
    var mockNavigationController: UINavigationController!
    let mockMenuController = MockMenuViewController()
    var coordinator: TopUpConfirmationCoordinator!
    
    override func setUpWithError() throws {
        mockDependenciesResolver = DependenciesDefault.mockInstance()
        mockNavigationController = MockNavigationController(rootViewController: mockMenuController)
        coordinator = TopUpConfirmationCoordinator(dependenciesResolver: mockDependenciesResolver,
                                                   navigationController: mockNavigationController,
                                                   summary: TopUpModel.mockInstance())
    
    }
    
    func testNotShowingConfirmationControllerBeforeStart() throws {
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testShowingConfirmationControllerOnStart() throws {
        coordinator.start()
        
        XCTAssert(mockNavigationController.viewControllers.count == 2)
        XCTAssert(mockNavigationController.topViewController is TopUpConfirmationViewController, "The top controller should be an instance of TopUpConfirmationViewController")
    }
    
    func testDismissingConfirmationControllerOnBack() throws {
        coordinator.start()
        coordinator.back()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testDismissingConfirmationControllerOnClose() throws {
        coordinator.start()
        coordinator.close()
        
        XCTAssert(mockNavigationController.viewControllers.count == 1, "There should be one controller on the stack")
        XCTAssert(mockNavigationController.topViewController is MockMenuViewController, "The top controller should be an instance of MockMenuViewController")
    }
    
    func testShowingSummary() throws {
        coordinator.start()
        coordinator.showSummary(with: TopUpModel.mockInstance())
        
        XCTAssert(mockNavigationController.viewControllers.count == 3)
        XCTAssert(mockNavigationController.topViewController is TopUpSummaryViewController, "The top controller should be an instance of TopUpSummaryViewController")
    }
}
