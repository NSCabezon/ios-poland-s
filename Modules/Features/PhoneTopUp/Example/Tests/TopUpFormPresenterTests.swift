//
//  TopUpFormPresenterTests.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 11/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI
@testable import PhoneTopUp

class TopUpFormPresenterTests: XCTestCase {
    
    var presenter: PhoneTopUpFormPresenter!
    var mockCoordinator: MockPhoneTopUpFormCoordinator!
    var dependenciesResolver: DependenciesDefault!
    var mockView: MockPhoneTopUpFormView!
    var mockGetContactUseCase: MockGetContactsUseCase!
    var mockCheckPhoneUseCase: MockCheckPhoneUseCase!
    var mockDialogProducer: MockDialogProducer!
    var mockAccount = [AccountForDebit.mockInstance()]
    var mockOperators = [Operator.mockInstance()]
    var mockInternetContacts = [MobileContact.mockInstance()]
    var mockTopUpSettings = TopUpSettings.mockInstance()
    var mockTopUpAccount = TopUpAccount.mockInstance()

    override func setUpWithError() throws {
        mockCoordinator = MockPhoneTopUpFormCoordinator()
        dependenciesResolver = DependenciesDefault.mockInstance()
        mockView = MockPhoneTopUpFormView()
        mockDialogProducer = MockDialogProducer()
        mockGetContactUseCase = MockGetContactsUseCase()
        mockCheckPhoneUseCase = MockCheckPhoneUseCase()
        registerDependencies()
        presenter = PhoneTopUpFormPresenter(
            dependenciesResolver: dependenciesResolver,
            accounts: mockAccount,
            operators: mockOperators,
            internetContacts: mockInternetContacts,
            settings: mockTopUpSettings,
            topUpAccount: mockTopUpAccount
        )
        presenter.view = mockView
    }
    
    func testDismissingViewOnBack() throws {
        presenter.didSelectBack()
        
        XCTAssert(mockCoordinator.backCallCount == 1)
    }
    
    func testShowingDialogOnClose() throws {
        presenter.didSelectClose()
        
        XCTAssert(mockDialogProducer.createDialogCallCount == 1)
        XCTAssert(mockView.showDialogCallCount == 1)
    }
    
    func testDismissingViewOnClose() throws {
        presenter.didSelectClose()
        
        XCTAssert(mockCoordinator.closeCallCount == 1)
    }
    
    func testUpdatingSelectedAccountsOnViewDidLoad() throws {
        presenter.viewDidLoad()
        
        XCTAssert(mockView.updateSelectedAccountCallCount == 1)
    }
    
    func testUpdatingContinueButtonOnVieDidLoad() {
        presenter.viewDidLoad()
        
        XCTAssert(mockView.updateContinueButtonCallCount == 1)
    }
    
    func testShowingAccountSelectorOnChangeAccount() {
        presenter.didSelectChangeAccount()
        
        XCTAssert(mockCoordinator.didSelectChangeAccountCallCount == 1)
    }
    
    func testShowingInternetContactsOnContactsButtonTouch() {
        presenter.didTouchContactsButton()
        
        XCTAssert(mockCoordinator.showInternetContactsCallcount == 1)
    }
    
    func testShowingOperatorSelectionOnOperatorSelectionButtonTouch() {
        presenter.didTouchOperatorSelectionButton()
        
        XCTAssert(mockCoordinator.showOperatorSelectionCallCount == 1)
    }
    
    func testUpdatingViewOnAccountSelection() {
        presenter.didSelectAccount(withAccountNumber: "12321")
        
        XCTAssert(mockView.updateSelectedAccountCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount == 1)
    }
    
    func testUpdatingViewOnContactSelection() {
        presenter.mobileContactsDidSelectContact(MobileContact.mockInstance())
        
        XCTAssert(mockView.updatePhoneInputCallCount == 1)
        XCTAssert(mockView.updateRecipientNameCallCount > 0)
        XCTAssert(mockView.updateOperatorSelectionCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testUpdatingViewOnOperatorSelection() {
        presenter.didSelectOperator(Operator.mockInstance())
        
        XCTAssert(mockView.updateOperatorSelectionCallCount == 1)
        XCTAssert(mockView.updatePaymentAmountsCallCount > 1)
        XCTAssert(mockView.showInvalidCustomAmountErrorCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testUpdatingViewOnTopUpAmountSelection() {
        presenter.didSelectTopUpAmount(TopUpAmount.custom(amount: 10))
        
        XCTAssert(mockView.updatePaymentAmountsCallCount == 1)
        XCTAssert(mockView.showInvalidCustomAmountErrorCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testUpdatingViewOnTermsButtonTouch() {
        presenter.didTouchTermsAndConditionsCheckBox()
        
        XCTAssert(mockView.updateTermsViewCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testUpdatingViewOnPartialPhoneNumberInput() {
        presenter.didInputPartialPhoneNumber("123456789")
        
        XCTAssert(mockView.updatePhoneInputCallCount == 1)
        XCTAssert(mockView.updateRecipientNameCallCount == 1)
        XCTAssert(mockView.showInvalidPhoneNumberErrorCallCount == 1)
        XCTAssert(mockView.updateOperatorSelectionCallCount > 0)
        XCTAssert(mockView.updatePaymentAmountsCallCount > 0)
        XCTAssert(mockView.showInvalidCustomAmountErrorCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testUpdatingViewOnFullPhoneNumberInput() {
        presenter.didInputFullPhoneNumber("123456789")
        
        XCTAssert(mockView.updatePhoneInputCallCount == 1)
        XCTAssert(mockView.updateRecipientNameCallCount == 1)
        XCTAssert(mockView.showInvalidPhoneNumberErrorCallCount == 1)
        XCTAssert(mockView.updateOperatorSelectionCallCount > 0)
        XCTAssert(mockView.updatePaymentAmountsCallCount > 0)
        XCTAssert(mockView.showInvalidCustomAmountErrorCallCount == 1)
        XCTAssert(mockView.updateContinueButtonCallCount > 0)
    }
    
    func testNotShowingConfirmationOnInvalidFormData() {
        presenter.didTouchContinueButton()
        
        XCTAssert(mockCoordinator.showTopUpConfirmationCallCount == 0)
    }
    
    func testShowingConfirmationOnValidFormData() {
        mockCheckPhoneUseCase.result = .ok(CheckPhoneUseCaseOutput(reloadPossible: true, result: ""))
        presenter.didSelectAccount(withAccountNumber: AccountForDebit.mockInstance().number)
        presenter.didInputFullPhoneNumber("601000001")
        presenter.didSelectOperator(Operator.mockInstance())
        presenter.didSelectTopUpAmount(TopUpAmount.custom(amount: 6))
        presenter.didTouchContinueButton()
        
        delayedTests {
            XCTAssert(self.mockView.showErrorDialogCallCount == 0)
            XCTAssert(self.mockCoordinator.showTopUpConfirmationCallCount == 1)
        }
    }
    
    func testShowingErrorWhenFormDataIsValidButReloadIsNotPossible() {
        mockCheckPhoneUseCase.result = .ok(CheckPhoneUseCaseOutput(reloadPossible: false, result: ""))
        presenter.didSelectAccount(withAccountNumber: AccountForDebit.mockInstance().number)
        presenter.didInputFullPhoneNumber("601000001")
        presenter.didSelectOperator(Operator.mockInstance())
        presenter.didSelectTopUpAmount(TopUpAmount.custom(amount: 6))
        presenter.didTouchContinueButton()
        
        delayedTests {
            XCTAssert(self.mockCoordinator.showTopUpConfirmationCallCount == 0)
            XCTAssert(self.mockView.showErrorDialogCallCount == 1)
        }
    }
    
    func testShowingErrorWhenFormDataIsValidButCheckPhoneIsAFailure() {
        mockCheckPhoneUseCase.result = .error(.init("Error"))
        presenter.didSelectAccount(withAccountNumber: AccountForDebit.mockInstance().number)
        presenter.didInputFullPhoneNumber("601000001")
        presenter.didSelectOperator(Operator.mockInstance())
        presenter.didSelectTopUpAmount(TopUpAmount.custom(amount: 6))
        presenter.didTouchContinueButton()
        
        delayedTests {
            XCTAssert(self.mockCoordinator.showTopUpConfirmationCallCount == 0)
            XCTAssert(self.mockView.showErrorDialogCallCount == 1)
        }
    }
}

private extension TopUpFormPresenterTests {
    func registerDependencies() {
        dependenciesResolver.register(for: PhoneTopUpFormCoordinatorProtocol.self) { _ in
            return self.mockCoordinator
        }
        
        dependenciesResolver.register(for: ConfirmationDialogProducing.self) { _ in
            return self.mockDialogProducer
        }
        
        self.dependenciesResolver.register(for: PaymentAmountCellViewModelMapping.self) { _ in
            return PaymentAmountCellViewModelMapper()
        }

        self.dependenciesResolver.register(for: CustomTopUpAmountValidating.self) { _ in
            return CustomTopUpAmountValidator()
        }
        
        self.dependenciesResolver.register(for: PartialPhoneNumberValidating.self) { _ in
            return PartialPhoneNumberValidator()
        }

        self.dependenciesResolver.register(for: ContactsPermissionHelperProtocol.self) { _ in
            return ContactsPermissionHelper()
        }
        
        dependenciesResolver.register(for: PolishContactsFiltering.self) { _ in
            return PolishContactsFilter()
        }
        
        self.dependenciesResolver.register(for: ContactMapping.self) { _ in
            return ContactMapper()
        }
        
        self.dependenciesResolver.register(for: TopUpFormValidating.self) { resolver in
            let customAmountValidator = resolver.resolve(for: CustomTopUpAmountValidating.self)
            let phoneNumberValidator = resolver.resolve(for: PartialPhoneNumberValidating.self)
            return TopUpFormValidator(customAmountValidator: customAmountValidator, numberValidator: phoneNumberValidator)
        }
        
        self.dependenciesResolver.register(for: GetContactsUseCaseProtocol.self) { resolver in
            return self.mockGetContactUseCase
        }
        
        self.dependenciesResolver.register(for: CheckPhoneUseCaseProtocol.self) { _ in
            return self.mockCheckPhoneUseCase
        }

        self.dependenciesResolver.register(for: PhoneTopUpFormViewController.self) { resolver in
            let presenter = resolver.resolve(for: PhoneTopUpFormPresenterProtocol.self)
            let viewController = PhoneTopUpFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        self.dependenciesResolver.register(for: ConfirmationDialogProducing.self) { _ in
            return self.mockDialogProducer
        }
        self.dependenciesResolver.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
    }
}
