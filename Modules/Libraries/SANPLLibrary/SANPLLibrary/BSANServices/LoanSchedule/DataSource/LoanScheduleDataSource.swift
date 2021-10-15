import Foundation

protocol LoanScheduleDataSourceProtocol {
    func getLoanSchedule(_ parameters: LoanScheduleParameters) throws -> Result<LoanScheduleDTO, NetworkProviderError>
}

private extension LoanScheduleDataSource {
    func getBaseUrl() -> String? {
        return try? self.dataProvider.getEnvironment().urlBase
    }
}

final class LoanScheduleDataSource {
    private enum LoanScheduleServiceType: String {
        case loanSchedule = "/accounts/loan/"
    }
    
    private let networkProvider: NetworkProvider
    private let dataProvider: BSANDataProvider
    private let basePath = "/api"
    
    init(networkProvider: NetworkProvider, dataProvider: BSANDataProvider) {
        self.networkProvider = networkProvider
        self.dataProvider = dataProvider
    }
}

extension LoanScheduleDataSource: LoanScheduleDataSourceProtocol {
    
    func getLoanSchedule(_ parameters: LoanScheduleParameters) throws -> Result<LoanScheduleDTO, NetworkProviderError> {
        guard let baseUrl = getBaseUrl() else {
            return .failure(NetworkProviderError.other)
        }
        return networkProvider.request(
            GetLoanScheduleRequest(
                serviceName:  "\(LoanScheduleServiceType.loanSchedule.rawValue)\(parameters.accountNumber)/payment-schedule",
                serviceUrl: baseUrl + self.basePath)
        )
    }
    
}
