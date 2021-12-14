//
//  GetHelpCenterSceneTypeUseCaseTests.swift
//  PLHelpCenter_Tests
//
//  Created by 186484 on 13/09/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import PLHelpCenter
import CoreFoundationLib
import SANPLLibrary
import XCTest

class GetHelpCenterSceneTypeUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()
    
    override func setUp() {
        super.setUp()

        setUpDependencies()
    }
    
    func test_useCase_withNotLoggedUser_shouldReturnContact() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged)
        let suite = dependencies.resolve(for: GetHelpCenterSceneTypeUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should Return contact scene")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                XCTAssertEqual(result.sceneType, HelpCenterSceneType.contact)
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withLoggedIndividualUser_shouldReturnDashboard() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual)
        let suite = dependencies.resolve(for: GetHelpCenterSceneTypeUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should Return dashboard scene")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                XCTAssertEqual(result.sceneType, HelpCenterSceneType.dashboard)
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: Constants.timeout)
    }

    func test_useCase_withLoggedCompanyUser_shouldReturnDashboardScene() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .company)
        let suite = dependencies.resolve(for: GetHelpCenterSceneTypeUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return dashboard scene")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                XCTAssertEqual(result.sceneType, HelpCenterSceneType.dashboard)
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
}

private extension GetHelpCenterSceneTypeUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetHelpCenterSceneTypeUseCase.self) { resolver in
            GetHelpCenterSceneTypeUseCase(dependenciesResolver: resolver)
        }

        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
    }
    
    func setUpManagersProvider(
        clientProfile: HelpCenterClientProfile,
        forceOnlineAdvisorError: Bool = false,
        forceHelpQuestionsError: Bool = false
    ) {
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            let mockData: PLHelpCenterMockData = PLHelpCenterMockData()
            mockData.forceOnlineAdvisorError = forceOnlineAdvisorError
            mockData.forceHelpQuestionsError = forceHelpQuestionsError
            return FakePLManagersProvider(
                mockData: mockData,
                clientProfileProvider: { clientProfile }
            )
        }
    }
}

