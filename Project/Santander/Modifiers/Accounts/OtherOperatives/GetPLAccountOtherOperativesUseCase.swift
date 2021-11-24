import SANLegacyLibrary
import DomainCommon
import Models
import Commons
import Account
import iOSPublicFiles
import RetailLegacy
import Repository

struct LoadPLAccountOtherOperativesInfoUseCaseImpl: AdditionalUseCasesProviderProtocol {
    let dependencies: DependenciesResolver

    func getAdditionalPublicFilesUseCases() -> [(useCase: UseCase<Void, Void, StringErrorOutput>, isMandatory: Bool)] {
        return [(LoadPLAccountOtherOperativesInfoUseCase(dependencies: dependencies, plAccountOtherOperativesInfoRepository: dependencies.resolve(for: PLAccountOtherOperativesInfoRepository.self), appRepository: dependencies.resolve(for: AppRepositoryProtocol.self)), isMandatory: true)]
    }
}

final class GetPLAccountOtherOperativesActionUseCase: UseCase<GetAccountOtherOperativesActionUseCaseInput, GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
 
    private let addBanks: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.addBanks.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_label_addBanks",
        icon: "icnBanks"
    )
    
    private let changeAlias: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.changeAliases.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "productOption_button_changeAlias",
        icon: "icnChangeAlias"
    )
    
    private let changeAccount: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.changeAccount.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_changeAccount",
        icon: "icnChangeAccountPL"
    )

    private let qrCode: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.generateQRCode.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_generateQR",
        icon: "icnQr"
    )

    private let alerts24: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.alerts24.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_alerts24",
        icon: "icnAlertConfig"
    )

    private let cardRepayment: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.creditCardRepayment.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "cardsOption_button_cardEntry",
        icon: "icnDepositCard"
    )

    private let editGoal: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.editGoal.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_editGoal",
        icon: "icnEditGoal"
    )

    private lazy var transactionHistory: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.history.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_transHistory",
        icon: "icnTransHistory"
    )

    private let accountStatements: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.accountStatement.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_statements",
        icon: "icnAccountStatements"
    )

    private let customerService: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.customerService.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_customerService",
        icon: "icnCustomerService"
    )

    private let openDeposit: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.openDeposit.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_openDeposit",
        icon: "icnOpenDeposit"
    )

    private let currencyExchange: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.fxExchange.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_currencyExchange",
        icon: "icnCurrencyExchange"
    )

    private let memberGetMember: AccountActionType = .custome(
        identifier: PLAccountOtherOperativesIdentifier.memberGetMember.rawValue,
        accesibilityIdentifier: "",
        trackName: "",
        localizedKey: "accountOption_button_friendPlan",
        icon: "icnMemberGetMember"
    )

    private lazy var everyDayOperatives: [AccountActionType] = {
        [addBanks, changeAlias, changeAccount, qrCode, alerts24, cardRepayment, editGoal]
    }()

    private lazy var otherOperativeActions: [AccountActionType] = {
        [addBanks, changeAlias, changeAccount, qrCode, alerts24, cardRepayment, editGoal, transactionHistory, accountStatements, customerService, openDeposit, currencyExchange, memberGetMember]
    }()

    private lazy var queriesActions: [AccountActionType] = {
        [transactionHistory, accountStatements, customerService]
    }()

    private lazy var contractActions: [AccountActionType] = {
        [openDeposit, currencyExchange, memberGetMember]
    }()
       
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: GetAccountOtherOperativesActionUseCaseInput) throws -> UseCaseResponse<GetAccountOtherOperativesActionUseCaseOkOutput, StringErrorOutput> {
        return .ok(GetAccountOtherOperativesActionUseCaseOkOutput(everyDayOperatives: everyDayOperatives, otherOperativeActions: otherOperativeActions, queriesActions: queriesActions, contractActions: contractActions, officeArrangementActions: []))
    }
}

extension GetPLAccountOtherOperativesActionUseCase: GetAccountOtherOperativesActionUseCaseProtocol {}
