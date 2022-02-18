import CoreFoundationLib
import SANPLLibrary
import PLCommons
import CoreDomain

public enum NotifyDeviceUseCaseErrorResult: String {
    case generalErrorMessages
    case authorizationError = "authorizationId not exists"
}

public protocol NotifyDeviceUseCaseProtocol: UseCase<NotifyDeviceUseCaseInput, NotifyDeviceUseCaseOutput, StringErrorOutput> {}

public final class NotifyDeviceUseCase: UseCase<NotifyDeviceUseCaseInput, NotifyDeviceUseCaseOutput, StringErrorOutput> {
    private let managersProvider: PLManagersProviderProtocol
    private let transferRepository: PLTransfersRepository
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.transferRepository = dependenciesResolver.resolve(for: PLTransfersRepository.self)
    }
    
    public override func executeUseCase(requestValues: NotifyDeviceUseCaseInput) throws -> UseCaseResponse<NotifyDeviceUseCaseOutput, StringErrorOutput> {
        
        let input = NotifyDeviceInput(challenge: requestValues.challenge,
                                      softwareTokenType: requestValues.softwareTokenType,
                                      notificationSchemaId: requestValues.notificationSchemaId,
                                      alias: requestValues.alias,
                                      iban: requestValues.iban,
                                      amount: requestValues.amount)
        let result = try self.transferRepository.notifyDevice(input)
        switch result {
        case .success(let authorizationId):
            if let authorizationId = authorizationId.authorizationId {
                return .ok(NotifyDeviceUseCaseOutput(authorizationId: authorizationId))
            }
            return .error(.init(NotifyDeviceUseCaseErrorResult.authorizationError.rawValue))
        case .failure(_):
            return .error(.init(NotifyDeviceUseCaseErrorResult.generalErrorMessages.rawValue))
        }
    }
}

extension NotifyDeviceUseCase: NotifyDeviceUseCaseProtocol {}

public struct NotifyDeviceUseCaseInput {
    let challenge: String
    let softwareTokenType: String?
    let notificationSchemaId: String
    let alias: String
    let iban: IBANRepresentable
    let amount: AmountRepresentable
    
    public init(
        challenge: String,
        softwareTokenType: String?,
        alias: String,
        iban: IBANRepresentable,
        amount: AmountRepresentable,
        notificationSchemaId: String = "195"
    ) {
        self.challenge = challenge
        self.softwareTokenType = softwareTokenType
        self.notificationSchemaId = notificationSchemaId
        self.alias = alias
        self.iban = iban
        self.amount = amount
    }
}

public struct NotifyDeviceUseCaseOutput {
    public let authorizationId: Int
    
    public init(authorizationId: Int) {
        self.authorizationId = authorizationId
    }
}
