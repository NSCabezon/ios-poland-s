import Commons
import DomainCommon
@testable import PLHelpCenter
import SANPLLibrary
import XCTest

class HelpCenterConversationTopicPresenterTests: XCTestCase {
    private let dependencies: DependenciesResolver & DependenciesInjector = DependenciesDefault()
    
    override func setUp() {
        super.setUp()

        setUpDependencies()
    }
    
    func test_conversationTopic_withSetUpAdvisorDetails_shouldHaveFullFilledViewModel() throws {
        // Arrange
        setUpManagersProvider()
        let mockedAdvisorsDetails = getMockedAdvisorDetails()
        let viewMock = HelpCenterConversationTopicViewMock()
        var suite = dependencies.resolve(for: HelpCenterConversationTopicPresenterProtocol.self)
        suite.view = viewMock
        
        // Act
        suite.setUp(with: mockedAdvisorsDetails)
        
        // Assert
        let viewModels = viewMock.viewModels
        
        XCTAssertEqual(viewModels.count, 1)
        XCTAssertEqual(viewModels.first?.elements.count, 3)
        
        let subjectDetail = viewModels.first?.elements[safe: 0]?.element.subjectDetails

        XCTAssertNotNil(subjectDetail)
        XCTAssertEqual(subjectDetail?.name, "Twoje produkty")
        XCTAssertEqual(subjectDetail?.entryType, "produktymobile")
        XCTAssertEqual(subjectDetail?.subjectId, "produkt")
        XCTAssertEqual(subjectDetail?.iconUrl, "https://micrositeoneapp2.santanderbankpolska.pl/oneapp/online-advisor/OnlineAdvisorMyProductsIco.png")
        XCTAssertEqual(subjectDetail?.loginActionRequired, false)
    }
    
    func test_conversationTopic_forUserContextWithoutLoginRequired_shouldReturnError() throws {
        // Arrange
        setUpManagersProvider(forceOnlineAdvisorUserContextError: true)
        let expectation = expectation(description: "Should show error dialog")
        let mockedSubjectDetails = HelpCenterConfig.SubjectDetails(name: "", entryType: "", subjectId: "", iconUrl: "", loginActionRequired: false)
        let viewMock = HelpCenterConversationTopicViewMock()
        var suite = dependencies.resolve(for: HelpCenterConversationTopicPresenterProtocol.self)
        suite.view = viewMock
        
        // Act
        suite.performActionFor(subjectDetails: mockedSubjectDetails, mediumType: "", baseAddress: "")
        
        // Assert
        viewMock.onShowError = {
            XCTAssertEqual(viewMock.willShowErrorDialogCalled, true)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: Constants.timeout)
    }
}

private extension HelpCenterConversationTopicPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: HelpCenterConversationTopicPresenterProtocol.self) { resolver in
            HelpCenterConversationTopicPresenter(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: HelpCenterConversationTopicViewProtocol.self) { _ in
            HelpCenterConversationTopicViewMock()
        }
        
        dependencies.register(for: GetHelpCenterConfigUseCase.self) { resolver in
            GetHelpCenterConfigUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: StringLoader.self) { _ in
            FakeStringLoader(currentLanguageProvider: { "pl" })
        }
        
        dependencies.register(for: GetUserContextForOnlineAdvisorUseCaseProtocol.self) { resolver in
            GetUserContextForOnlineAdvisorUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: UseCaseScheduler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
    }
    
    func setUpManagersProvider(forceOnlineAdvisorUserContextError: Bool = false) {
        dependencies.register(for: PLManagersProviderProtocol.self) { _ in
            let mockData = PLHelpCenterMockData()
            mockData.forceOnlineAdvisorUserContextError = forceOnlineAdvisorUserContextError
            return FakePLManagersProvider(mockData: mockData, clientProfileProvider: { .individual })
        }
    }
        
    func getMockedAdvisorDetails() -> HelpCenterConfig.AdvisorDetails {
        let useCase = GetHelpCenterConfigUseCase(dependenciesResolver: dependencies)
        let helpCenterConfig = try? useCase.executeUseCase(requestValues: ()).getOkResult().helpCenterConfig
        
        guard let advisor = helpCenterConfig?.sections
            .first(where: { $0.section.isOnlineAdvisor })?.elements
            .first(where: { $0.isAdvisor }),
            case .advisor(_, _, let details) = advisor
        else { fatalError() }
   
        return details
    }
}

private extension HelpCenterConfig.SectionType {
    var isOnlineAdvisor: Bool {
        if case .onlineAdvisor = self { return true } else { return false }
    }
}

private extension HelpCenterConfig.Element {
    var isAdvisor: Bool {
        if case .advisor = self { return true } else { return false }
    }

    var subjectDetails: HelpCenterConfig.SubjectDetails? {
        guard case .subject(let details) = self else { return nil }
        
        return details
    }
}
