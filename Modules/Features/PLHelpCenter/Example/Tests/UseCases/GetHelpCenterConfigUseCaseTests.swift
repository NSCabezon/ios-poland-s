//
//  GetAccountsUseCaseTests.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 13/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Commons
@testable import PLHelpCenter
import DomainCommon
import SANPLLibrary
import XCTest

class GetHelpCenterConfigUseCaseTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()
    
    override func setUp() {
        super.setUp()

        setUpDependencies()
    }
    
    func test_useCase_withNotLoggedUser_shouldReturnOneSectionWithManyElements() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should Return contact section with call and advisor elements")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 1)
                XCTAssertTrue(sections[0].section.isContact)
                let elements = sections[0].elements
                XCTAssertEqual(elements.count(off: { $0.isCall }), 1)
                XCTAssertGreaterThanOrEqual(elements.count(off: { $0.isAdvisor }), 1)
                
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withNotLoggedUserAndNotSupportedLocale_shouldReturnOneSectionWithManyElements() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged)
        setUpLanguageProvider(locale: "ru")
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should Return contact section with call, info and advisor elements")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 1)
                XCTAssertTrue(sections[0].section.isContact)
                let elements = sections[0].elements
                XCTAssertEqual(elements.count(off: { $0.isCall }), 1)
                XCTAssertEqual(elements.count(off: { $0.isInfo }), 1)
                XCTAssertGreaterThanOrEqual(elements.count(off: { $0.isAdvisor }), 1)
                
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: Constants.timeout)
    }

    func test_useCase_withNotLoggedUserAndError_shouldReturnOnlySectionWithCallElement() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .notLogged, forceOnlineAdvisorError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return contact section with just call element")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 1)
                XCTAssertTrue(sections[0].section.isContact)
                let elements = sections[0].elements
                XCTAssertEqual(elements.count(off: { $0.isCall }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withUser_shouldReturnAllSections() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return hints, call and online advisor section")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 3)
                
                let hintsSection = sections[0]
                XCTAssertTrue(hintsSection.section.isHints)
                XCTAssertGreaterThanOrEqual(hintsSection.elements.count(off: { $0.isExpandableHint }), 1)
                
                let callSection = sections[1]
                XCTAssertTrue(callSection.section.isCall)
                XCTAssertEqual(callSection.elements.count(off: { $0.isCall }), 1)
                
                let advisorSection = sections[2]
                XCTAssertTrue(advisorSection.section.isOnlineAdvisor)
                XCTAssertGreaterThanOrEqual(advisorSection.elements.count(off: { $0.isAdvisor }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withUserAndNotSupportedLocale_shouldReturnAllSectionsAndInfoElement() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual)
        setUpLanguageProvider(locale: "ru")
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return hints, call and online advisor (with additional info) section")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 3)
                
                let hintsSection = sections[0]
                XCTAssertTrue(hintsSection.section.isHints)
                XCTAssertGreaterThanOrEqual(hintsSection.elements.count(off: { $0.isExpandableHint }), 1)
                
                let callSection = sections[1]
                XCTAssertTrue(callSection.section.isCall)
                XCTAssertEqual(callSection.elements.count(off: { $0.isCall }), 1)
                
                let advisorSection = sections[2]
                XCTAssertTrue(advisorSection.section.isOnlineAdvisor)
                XCTAssertEqual(advisorSection.elements.count(off: { $0.isInfo }), 1)
                XCTAssertGreaterThanOrEqual(advisorSection.elements.count(off: { $0.isAdvisor }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withUserAndTotalError_shouldReturnOnlyCallSection() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual, forceOnlineAdvisorError: true, forceHelpQuestionsError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return only call section")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 1)
                
                let callSection = sections[0]
                XCTAssertTrue(callSection.section.isCall)
                XCTAssertEqual(callSection.elements.count(off: { $0.isCall }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withUserAndOnlineAdvisorError_shouldReturnHintsAndCallSections() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual, forceOnlineAdvisorError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return hints and call section")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 2)
                
                let hintsSection = sections[0]
                XCTAssertTrue(hintsSection.section.isHints)
                XCTAssertGreaterThanOrEqual(hintsSection.elements.count(off: { $0.isExpandableHint }), 1)
                
                
                let callSection = sections[1]
                XCTAssertTrue(callSection.section.isCall)
                XCTAssertEqual(callSection.elements.count(off: { $0.isCall }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
    
    func test_useCase_withUserAndHelpQuestionsError_shouldReturnCallAndAdvisorSections() throws {
        // Arrange
        setUpManagersProvider(clientProfile: .individual, forceHelpQuestionsError: true)
        setUpLanguageProvider()
        let suite = dependencies.resolve(for: GetHelpCenterConfigUseCase.self)
        let useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
        let expectation = expectation(description: "Should return call and advisor section")
        
        // Act
        UseCaseWrapper(
            with: suite,
            useCaseHandler: useCaseHandler,
            onSuccess: { result in
                // Assert
                let sections = result.helpCenterConfig.sections
                XCTAssertEqual(sections.count, 2)
                
                let callSection = sections[0]
                XCTAssertTrue(callSection.section.isCall)
                XCTAssertEqual(callSection.elements.count(off: { $0.isCall }), 1)
                
                let advisorSection = sections[1]
                XCTAssertTrue(advisorSection.section.isOnlineAdvisor)
                XCTAssertGreaterThanOrEqual(advisorSection.elements.count(off: { $0.isAdvisor }), 1)
                
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension GetHelpCenterConfigUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetHelpCenterConfigUseCase.self) { resolver in
            GetHelpCenterConfigUseCase(dependenciesResolver: resolver)
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
    
    func setUpLanguageProvider(locale: String = "pl") {
        dependencies.register(for: StringLoader.self) { _ in
            return FakeStringLoader(currentLanguageProvider: { locale } )
        }
    }
}

private extension HelpCenterConfig.SectionType {
    var isCall: Bool {
        if case .call = self { return true } else { return false }
    }
    
    var isHints: Bool {
        if case .hints = self { return true } else { return false }
    }
    
    var isOnlineAdvisor: Bool {
        if case .onlineAdvisor = self { return true } else { return false }
    }
    
    var isContact: Bool {
        if case .contact = self { return true } else { return false }
    }
}

private extension HelpCenterConfig.Element {
    
    var isCall: Bool {
        if case .call = self { return true } else { return false }
    }
    
    var isInfo: Bool {
        if case .info = self { return true } else { return false }
    }
    
    var isExpandableHint: Bool {
        if case .expandableHint = self { return true } else { return false }
    }
    
    var isAdvisor: Bool {
        if case .advisor = self { return true } else { return false }
    }
}

private extension Array where Element == HelpCenterConfig.Element {
    func count(off condition: (Element) -> Bool) -> Int {
        filter(condition).count
    }
}
