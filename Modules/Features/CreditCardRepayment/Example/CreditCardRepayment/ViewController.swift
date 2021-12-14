import UIKit
import CreditCardRepayment
import Commons
import CoreFoundationLib
import Repository
import SANPLLibrary
import SANLegacyLibrary
import UI
import Models

final class ViewController: UIViewController {
    
    private lazy var coordinator = CreditCardRepaymentModuleCoordinator(
        dependenciesResolver: dependenciesResolver,
        navigationController: navigationController
    )
    
    private var mockData: CreditCardRepaymentManagerMockData = CreditCardRepaymentManagerMockData(multipleChoices: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        UIStyle.setup()
    }
    
    private func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("Module Menu")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectClose() {} // Just to fix bug, it seems that at least one image must be loaded before calling UIStyle.setup()
    
    @IBAction func singleCaseTapped(_ sender: Any) {
        mockData = CreditCardRepaymentManagerMockData(multipleChoices: false)
        coordinator.start()
    }
    
    @IBAction func multipleCaseTapped(_ sender: Any) {
        mockData = CreditCardRepaymentManagerMockData(multipleChoices: true)
        coordinator.start()
    }
    
    @IBAction func startWithPredefinedAccountNumberTapped(_ sender: Any) {
        mockData = CreditCardRepaymentManagerMockData(multipleChoices: true)
        var cardDTO = SANLegacyLibrary.CardDTO()
        cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: "545250P038230083")
        coordinator.start(with: CardEntity(cardDTO))
    }
    
    internal lazy var dependenciesResolver: DependenciesResolver = {
        let defaultResolver = DependenciesDefault()
        
        defaultResolver.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: UseCaseScheduler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8, qualityOfService: .userInitiated)
        }
        
        defaultResolver.register(for: AppConfigRepositoryProtocol.self) { _ in
            return FakeAppConfigRepository()
        }
        
        defaultResolver.register(for: PLManagersProviderProtocol.self) { [unowned self]_ in
            return FakePLManagersProvider(mockData: self.mockData)
        }
        
        defaultResolver.register(for: BSANDataProviderProtocol.self) { [unowned self] _ in
            return FakeBSANDataProvider()
        }
        
        return defaultResolver
    }()
}

final class FakeAppConfigRepository: AppConfigRepositoryProtocol {
    func getAppConfigListNode<T>(_ nodeName: String, object: T.Type, options: AppConfigDecodeOptions) -> [T]? where T : Decodable {
        nil
    }
    
    func getBool(_ nodeName: String) -> Bool? {
        nil
    }
    
    func getDecimal(_ nodeName: String) -> Decimal? {
        nil
    }
    
    func getInt(_ nodeName: String) -> Int? {
        nil
    }
    
    func getString(_ nodeName: String) -> String? {
        nil
    }
    
    func getAppConfigListNode(_ nodeName: String) -> [String]? {
        nil
    }
}

final class FakePLManagersProvider: PLManagersProviderProtocol {
  
    init(mockData: CreditCardRepaymentManagerMockData) {
        self.mockData = mockData
    }
    
    private let mockData: CreditCardRepaymentManagerMockData
    
    func getAccountsManager() -> PLAccountManagerProtocol {
        fatalError()
    }
    
    func getEnvironmentsManager() -> PLEnvironmentsManagerProtocol {
        fatalError()
    }
    
    func getCustomerManager() -> PLCustomerManagerProtocol {
        fatalError()
    }
    
    func getLoginManager() -> PLLoginManagerProtocol {
        fatalError()
    }
    
    func getBLIKManager() -> PLBLIKManagerProtocol {
        fatalError()
    }
    
    func getCreditCardRepaymentManager() -> PLCreditCardRepaymentManagerProtocol {
        FakePLCreditCardRepaymentManager(mockData: mockData)
    }
    
    func getTrustedDeviceManager() -> PLTrustedDeviceManager {
        fatalError()
    }
    
    func getGlobalPositionManager() -> PLGlobalPositionManagerProtocol {
        FakePLGlobalPositionManager(mockData: mockData)
    }
    
    func getCardsManager() -> PLCardsManagerProtocol {
        fatalError()
    }
    
    func getCardTransactionsManager() -> PLCardTransactionsManagerProtocol {
        fatalError()
    }
    
    func getHelpCenterManager() -> PLHelpCenterManagerProtocol {
        fatalError()
    }
    
    func getLoanScheduleManager() -> PLLoanScheduleManagerProtocol {
        fatalError()
    }
    
    func getNotificationManager() -> PLNotificationManagerProtocol {
        fatalError()
    }
    
    func getTransferManager() -> PLTransfersManagerProtocol {
        fatalError()
    }
}

final class FakePLCreditCardRepaymentManager: PLCreditCardRepaymentManagerProtocol {
    
    init(mockData: CreditCardRepaymentManagerMockData) {
        self.mockData = mockData
    }
    
    private let mockData: CreditCardRepaymentManagerMockData
    
    func getCards() throws -> Result<[CCRCardDTO], NetworkProviderError> {
        guard let gpCards = mockData.globalPosition.cards else { return .failure(.other) }
        let accounts = mockData.ccrAccountsForCredit
        
        let cards = gpCards
            .filter { $0.type == "CREDIT"}
            .map { card -> CCRCardDTO in
                let account = accounts.first { card.relatedAccount == $0.number }
                return CCRCardDTO.mapFromCardDTO(card, account: account)
            }
        return .success(cards)
    }
    
    func getAccountsForDebit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        .success(mockData.ccrAccountsForDebit)
    }
    
    func getAccountsForCredit() throws -> Result<[CCRAccountDTO], NetworkProviderError> {
        .success(mockData.ccrAccountsForCredit)
    }
    
    func sendRepayment(_ parameters: AcceptDomesticTransactionParameters) throws -> Result<AcceptDomesticTransferSummaryDTO, NetworkProviderError> {
        .success(mockData.ccrSummaryDTO)
    }
    
}

final class FakePLGlobalPositionManager: PLGlobalPositionManagerProtocol {
    init(mockData: CreditCardRepaymentManagerMockData) {
        self.mockData = mockData
    }
    
    private let mockData: CreditCardRepaymentManagerMockData
    
    func getAllProducts() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        return .success(mockData.globalPosition)
    }
    
    func getAccounts() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        try getAllProducts()
    }
    
    func getCards() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        try getAllProducts()
    }
    
    func getLoans() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        try getAllProducts()
    }
    
    func getDeposits() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        try getAllProducts()
    }
    
    func getInvestmentFunds() throws -> Result<SANPLLibrary.GlobalPositionDTO, NetworkProviderError> {
        try getAllProducts()
    }
    
    func getGlobalPosition() -> SANPLLibrary.GlobalPositionDTO? {
        return mockData.globalPosition
    }
}

final class FakeBSANDataProvider: BSANDataProviderProtocol {
    
    func getAuthCredentialsProvider() throws -> AuthCredentialsProvider {
        return SANPLLibrary.AuthCredentials(login: nil, userId: nil, userCif: nil, companyContext: nil, accessTokenCredentials: nil, trustedDeviceTokenCredentials: nil)
    }
    
    public func getLanguageISO() throws -> String {
        return "pl"
    }
    
    public func getDialectISO() throws -> String {
        return "PL"
    }
    
    public func store(creditCardRepaymentAccounts accounts: [CCRAccountDTO]) {
        
    }
    
    public func store(creditCardRepaymentCards cards: [CCRCardDTO]) {
        
    }

    public func getCreditCardRepaymentInfo() -> CreditCardRepaymentInfo? {
        return nil
    }
    
    public func cleanCreditCardRepaymentInfo() {
        
    }
}
