//
//  TopUpDataLoaderPresenterTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import SANPLLibrary
import PLCommons
@testable import PhoneTopUp

class TopUpDataLoaderPresenterTests: XCTestCase {
    
    var presenter: TopUpDataLoaderPresenter!
    var mockUseCase: MockGetPhoneTopUpFormDataUseCase!
    var mockCoordinator: MockTopUpDataLoaderCoordinator!
    var dependenciesResolver: DependenciesDefault!
    var mockView: MockTopUpDataLoaderView!

    override func setUpWithError() throws {
        dependenciesResolver = DependenciesDefault.mockInstance()
        mockUseCase = MockGetPhoneTopUpFormDataUseCase()
        mockCoordinator = MockTopUpDataLoaderCoordinator()
        mockView = MockTopUpDataLoaderView()
        registerDependencies()
        presenter = TopUpDataLoaderPresenter(dependenciesResolver: dependenciesResolver, settings: TopUpSettings.mockInstance())
        presenter.view = mockView
    }
    
    private func registerDependencies() {
        dependenciesResolver.register(for: TopUpDataLoaderCoordinatorProtocol.self) { _ in
            return self.mockCoordinator
        }
        
        dependenciesResolver.register(for: UseCaseScheduler.self) { _ in
            return DispatchQueue.main
        }
        
        dependenciesResolver.register(for: GetPhoneTopUpFormDataUseCaseProtocol.self) { _ in
            return self.mockUseCase
        }
    }

    func testNotFetchingDataBeforeViewDidLoad() throws {
        XCTAssert(!mockUseCase.didCallExecuteUseCase)
    }
    
    func testFetchingDataOnViewDidLoad() throws {
        presenter.viewDidLoad()
        
        XCTAssert(mockUseCase.didCallExecuteUseCase)
    }
    
    func testShowingErrorAferFetchFail() throws {
        mockUseCase.result = .error(.init("Error"))
        presenter.viewDidLoad()
        
        delayedTests {
            XCTAssert(self.mockView.showLoaderCallCount == 1)
            XCTAssert(self.mockView.hideLoaderCallCount == 1)
            XCTAssert(self.mockView.showErrorMessageCallCount == 1)
        }
    }
    
    func testShowingErrorAfterNoAccountsFetched() throws {
        mockUseCase.result = .ok(GetPhoneTopUpFormDataOutput(accounts: [], operators: [], internetContacts: [], topUpAccount: TopUpAccount.mockInstance()))
        presenter.viewDidLoad()
        
        delayedTests {
            XCTAssert(self.mockView.showLoaderCallCount == 1)
            XCTAssert(self.mockView.hideLoaderCallCount == 1)
            XCTAssert(self.mockView.showErrorMessageCallCount == 1)
            XCTAssert(!self.mockCoordinator.didCallShowForm)
        }
    }
    
    func testShowingFormAfterSuccessfulFetch() throws {
        mockUseCase.result = .ok(GetPhoneTopUpFormDataOutput(accounts: [AccountForDebit.mockInstance()], operators: [Operator.mockInstance()], internetContacts: [], topUpAccount: TopUpAccount.mockInstance()))
        presenter.viewDidLoad()
        
        delayedTests {
            XCTAssert(self.mockCoordinator.didCallShowForm)
        }
    }
}
