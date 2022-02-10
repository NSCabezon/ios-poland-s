//
//  GetHelpCenterUserContextForOnlineAdvisorUseCaseTests.swift
//  PLHelpCenter_Tests
//
//  Created by 186484 on 19/10/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import SANPLLibrary
@testable import PLHelpCenter

class GetHelpCenterUserContextForOnlineAdvisorUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()
    
    override func setUp() {
        super.setUp()

        setUpDependencies()
    }
    
    func test_useCase_for_UserContext_ForOnlineAdvisor_BeforeLogin() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetUserContextForOnlineAdvisorUseCase.self)
        let requestedValue = GetUserContextForOnlineAdvisorUseCaseOkInput(entryType: "",
                                                                          mediumType: "",
                                                                          subjectID: "",
                                                                          baseAddress: "")
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should Return pDate object")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: useCaseScheduler)
            .onSuccess { output in
                // Assert
                XCTAssertNotNil(output)
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_for_UserContext_ForOnlineAdvisor_AfterLogin() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetUserContextForOnlineAdvisorUseCase.self)
        let requestedValue = GetUserContextForOnlineAdvisorUseCaseOkInput(entryType: "",
                                                                          mediumType: "",
                                                                          subjectID: "",
                                                                          baseAddress: "")
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should Return pDate object")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: useCaseScheduler)
            .onSuccess { output in
                // Assert
                XCTAssertNotNil(output)
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_for_UserContext_ForOnlineAdvisor_BeforeLogin_ShouldReturn_Error() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged, forceOnlineAdvisorUserContextError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetUserContextForOnlineAdvisorUseCase.self)
        let requestedValue = GetUserContextForOnlineAdvisorUseCaseOkInput(entryType: "",
                                                                          mediumType: "",
                                                                          subjectID: "",
                                                                          baseAddress: "")
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should return featchingTrouble error on error")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: useCaseScheduler)
            .onError { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_for_UserContextForOnlineAdvisor_ShouldReturn_Error() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual, forceOnlineAdvisorUserContextError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetUserContextForOnlineAdvisorUseCase.self)
        let requestedValue = GetUserContextForOnlineAdvisorUseCaseOkInput(entryType: "",
                                                                          mediumType: "",
                                                                          subjectID: "",
                                                                          baseAddress: "")
        let useCaseScheduler = dependencies.resolve(for: UseCaseScheduler.self)
        let expectation = expectation(description: "Should return featchingTrouble error on error")
        
        // Act
        Scenario(useCase: suite, input: requestedValue)
            .execute(on: useCaseScheduler)
            .onError { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: Constants.timeout)
    }
                
}

private extension GetHelpCenterUserContextForOnlineAdvisorUseCaseTests {
    
    func setUpDependencies() {
        dependencies.register(for: GetUserContextForOnlineAdvisorUseCase.self) { resolver in
            GetUserContextForOnlineAdvisorUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: UseCaseScheduler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
    }
    
    func setUpManagersProvider(
        clientProfile: HelpCenterClientProfile,
        forceOnlineAdvisorError: Bool = false,
        forceHelpQuestionsError: Bool = false,
        forceOnlineAdvisorUserContextError: Bool = false
    ) {
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            let mockData: PLHelpCenterMockData = PLHelpCenterMockData()
            mockData.forceOnlineAdvisorError = forceOnlineAdvisorError
            mockData.forceHelpQuestionsError = forceHelpQuestionsError
            mockData.forceOnlineAdvisorUserContextError = forceOnlineAdvisorUserContextError
            return FakePLManagersProvider(
                mockData: mockData,
                clientProfileProvider: { clientProfile }
            )
        }
    }
    
    func setUpLanguageProvider(locale: String = "pl") {
        dependencies.register(for: StringLoader.self) { _ in
            return FakeStringLoader(currentLanguageProvider: { locale } )
        }
    }
    
}
