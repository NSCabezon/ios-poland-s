import Commons
import CoreFoundationLib
import CryptoSwift
import Contacts

public protocol GetContactsUseCaseProtocol: UseCase<Void, GetContactsUseCaseOutput, StringErrorOutput> {}


public final class GetContactsUseCase: UseCase<Void, GetContactsUseCaseOutput, StringErrorOutput> {
    private let contactStore: CNContactStore
    private let contactMapper: ContactMapping

    public init(contactStore: CNContactStore, contactMapper: ContactMapping) {
        self.contactStore = contactStore
        self.contactMapper = contactMapper
    }
    
    public override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetContactsUseCaseOutput, StringErrorOutput> {
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try contactStore.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
        } catch {
            return .error(.init(error.localizedDescription))
        }
        
        let mappedContacts = contactMapper.map(contacts: contacts)
        
        return .ok(
            GetContactsUseCaseOutput(contacts: mappedContacts)
        )
    }
}

extension GetContactsUseCase: GetContactsUseCaseProtocol {}

public struct GetContactsUseCaseOutput {
    public let contacts: [MobileContact]
}
