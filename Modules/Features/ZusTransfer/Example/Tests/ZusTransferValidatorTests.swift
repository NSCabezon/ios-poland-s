import XCTest
import CoreFoundationLib
import PLCommons
@testable import ZusTransfer

private enum Consts {
    static let maskAccountConst = "__60000002026_____________"
}

final class ZusTransferValidatorTests: XCTestCase {
    private var sut: ZusTransferValidating?
    private var dependencies: (DependenciesResolver & DependenciesInjector)?

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        sut = dependencies?.resolve(for: ZusTransferValidating.self)
    }
    
    override func tearDown() {
        sut = nil
        dependencies = nil
        super.tearDown()
    }
    
    func test_validateForm_called_for_recipient() throws {
        let sut = try XCTUnwrap(sut)
        let recipientEmptyViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 1,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let recipientEmptyZusTransferFormData = sut.validateForm(
            form: recipientEmptyViewModel,
            with: .recipient,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(recipientEmptyZusTransferFormData.invalidRecieptMessages)
        
        let recieptCorrectViewModel = ZusTransferFormViewModel(
            recipient: "Zus",
            amount: 1,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let recipientCorrectZusTransferFormData = sut.validateForm(
            form: recieptCorrectViewModel,
            with: .recipient,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNil(recipientCorrectZusTransferFormData.invalidRecieptMessages)
    }
    
    func test_validateForm_called_for_title() throws {
        let sut = try XCTUnwrap(sut)
        let titleEmptyViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 1,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let titleEmptyZusTransferFormData = sut.validateForm(
            form: titleEmptyViewModel,
            with: .title,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(titleEmptyZusTransferFormData.invalidTitleMessages)
        
        let titleCorrectViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 1,
            title: "sample",
            date: Date(),
            recipientAccountNumber: ""
        )
        let titleCorrectZusTransferFormData = sut.validateForm(
            form: titleCorrectViewModel,
            with: .title,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNil(titleCorrectZusTransferFormData.invalidTitleMessages)
    }
    
    func test_validateForm_called_for_amount() throws {
        let sut = try XCTUnwrap(sut)
        let amountEmptyViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: -1,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let amountEmptyZusTransferFormData = sut.validateForm(
            form: amountEmptyViewModel,
            with: .amount,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(amountEmptyZusTransferFormData.invalidAmountMessages)
       
        let amountZeroViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 0,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let amountZeroZusTransferFormData = sut.validateForm(
            form: amountZeroViewModel,
            with: .amount,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(amountZeroZusTransferFormData.invalidAmountMessages)

        let amountHigherThanMaxViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 100_001,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let amountHigherZusTransferFormData = sut.validateForm(
            form: amountHigherThanMaxViewModel,
            with: .amount,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(amountHigherZusTransferFormData.invalidAmountMessages)
        
        let amountCorrectViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 1.1,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let amountCorrectZusTransferFormData = sut.validateForm(
            form: amountCorrectViewModel,
            with: .amount,
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNil(amountCorrectZusTransferFormData.invalidAmountMessages)
    }
    
    func test_validateForm_called_for_accountNumber() throws {
        let sut = try XCTUnwrap(sut)
        let accountNumberEmptyViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 0,
            title: "",
            date: Date(),
            recipientAccountNumber: ""
        )
        let accountNumberEmptyTransferFormData = sut.validateForm(
            form: accountNumberEmptyViewModel,
            with: .accountNumber(controlEvent: .endEditing),
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(accountNumberEmptyTransferFormData.invalidAccountMessages)
        
        let accountNumberBadLenghtViewModel = ZusTransferFormViewModel(
            recipient: "Zus",
            amount: 0,
            title: "",
            date: Date(),
            recipientAccountNumber: "26109000880000000142230"
        )
        let accountNumberBadLenghtTransferFormData = sut.validateForm(
            form: accountNumberBadLenghtViewModel,
            with: .accountNumber(controlEvent: .endEditing),
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(accountNumberBadLenghtTransferFormData.invalidAccountMessages)
        
        let accountNumberBadMasktViewModel = ZusTransferFormViewModel(
            recipient: "Zus",
            amount: 0,
            title: "",
            date: Date(),
            recipientAccountNumber: "26109000880000000142230553"
        )
        let accountNumberBadMaskTransferFormData = sut.validateForm(
            form: accountNumberBadMasktViewModel,
            with: .accountNumber(controlEvent: .endEditing),
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNotNil(accountNumberBadMaskTransferFormData.invalidAccountMessages)
        
        let accountNumbertCorrectViewModel = ZusTransferFormViewModel(
            recipient: "",
            amount: 0,
            title: "",
            date: Date(),
            recipientAccountNumber: "82600000020260017772273629"
        )
        let accountNumbertTransferFormData = sut.validateForm(
            form: accountNumbertCorrectViewModel,
            with: .accountNumber(controlEvent: .endEditing),
            maskAccount: Consts.maskAccountConst
        )
        XCTAssertNil(accountNumbertTransferFormData.invalidAccountMessages)
    }
}
     
private extension ZusTransferValidatorTests {
    func setUpDependencies() {
        dependencies?.register(for: BankingUtilsProtocol.self) { resolver in
            BankingUtils(dependencies: resolver)
        }
        
        dependencies?.register(for: ZusTransferValidating.self) { resolver in
            ZusTransferValidator(dependenciesResolver: resolver)
        }
    }
}
