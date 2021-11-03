import Foundation

public protocol PLLoanScheduleManagerProtocol {
    func getLoanSchedule(_ parameters: LoanScheduleParameters) throws -> Result<LoanScheduleDTO, NetworkProviderError>
}

public final class PLLoanScheduleManager {
    private let dataSource: LoanScheduleDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    
    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.dataSource = LoanScheduleDataSource(
            networkProvider: networkProvider,
            dataProvider: bsanDataProvider
        )
        self.bsanDataProvider = bsanDataProvider
    }
}

extension PLLoanScheduleManager: PLLoanScheduleManagerProtocol {
    public func getLoanSchedule(_ parameters: LoanScheduleParameters) throws -> Result<LoanScheduleDTO, NetworkProviderError> {
        return try dataSource.getLoanSchedule(parameters)
    }
}
