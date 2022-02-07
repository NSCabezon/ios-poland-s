import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol GetPSPTicketProtocol: UseCase<Void, GetPSPTicketUseCaseOkOutput, StringErrorOutput> {}

final class GetPSPTicket: UseCase<Void, GetPSPTicketUseCaseOkOutput, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private let managersProvider: PLManagersProviderProtocol
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetPSPTicketUseCaseOkOutput, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getPSPTicket()
        switch result {
        case .success(let dto):
            return UseCaseResponse.ok(GetPSPTicketUseCaseOkOutput(code: dto.ticket, secondsRemaining: TimeInterval(dto.ticketTime)))
        case .failure(let error):
            return UseCaseResponse.error(.init(error.localizedDescription))
        }
    }
}

extension GetPSPTicket: GetPSPTicketProtocol {}

struct GetPSPTicketUseCaseOkOutput {
    let code: String
    let secondsRemaining: TimeInterval
}
