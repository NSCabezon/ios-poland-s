import SANPLLibrary
import Commons
import PLCommons

final class PLTransactionParametersProviderMock: PLTransactionParametersProviderProtocol {
  
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getTransactionParameters(type: PLDomesticTransactionParametersType?) -> TransactionParameters? {
        nil
    }
}
