import Foundation

public protocol PLQuickBalanceManagerProtocol {
    func getQuickBalanceLastTransaction() throws -> Result<PLQuickBalanceDTO, NetworkProviderError>
    func getQuickBalanceSettings() throws -> Result<[PLGetQuickBalanceSettingsDTO], NetworkProviderError>
    func confirmQuickBalance(accounts: [PLQuickBalanceConfirmParameterDTO]?) throws -> Result<Void, NetworkProviderError>
}

public final class PLQuickBalanceManager {
    private let quickBalanceDataSource: PLQuickBalanceDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoUserProtocol

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, demoInterpreter: DemoUserProtocol) {
        self.quickBalanceDataSource = PLQuickBalanceDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = demoInterpreter
    }
}

extension PLQuickBalanceManager: PLQuickBalanceManagerProtocol {

    public func getQuickBalanceLastTransaction() throws -> Result<PLQuickBalanceDTO, NetworkProviderError> {
        return try quickBalanceDataSource.getQuickBalanceLastTransaction()
    }

    public func getQuickBalanceSettings() throws -> Result<[PLGetQuickBalanceSettingsDTO], NetworkProviderError> {
        return try quickBalanceDataSource.getQuickBalanceSettings()
    }

    public func confirmQuickBalance(accounts: [PLQuickBalanceConfirmParameterDTO]?) throws -> Result<Void, NetworkProviderError> {
        return try quickBalanceDataSource.confirmQuickBalance(accounts: accounts)
    }
}
