import CoreFoundationLib
import CoreDomain
import PersonalArea

private let phoneContact = "+48 61 81 19999"

final class PLGetContactPhonesUseCase: UseCase<Void, GetContactPhonesUseCaseOutput, StringErrorOutput> {
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetContactPhonesUseCaseOutput, StringErrorOutput> {
        let output = GetContactPhonesUseCaseOutput(cardBlock: PLContactPhoneEntity(numbers: [phoneContact]), fraude: PLContactPhoneEntity(numbers: [phoneContact]))
        return .ok(output)
    }
}

extension PLGetContactPhonesUseCase: GetContactPhonesUseCaseProtocol { }

private final class PLContactPhoneEntity {
    let title: String?
    let desc: String?
    let numbers: [String]?
    
    init(numbers: [String]?) {
        self.title = nil
        self.desc = nil
        self.numbers = numbers
    }
}

extension PLContactPhoneEntity: ContactPhoneRepresentable { }
