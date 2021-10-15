import Foundation
import Contacts
import DomainCommon
import SANPLLibrary

protocol GetContactsUseCaseProtocol: UseCase<Void, [Contact], StringErrorOutput> {}


final class GetContactsUseCase: UseCase<Void, [Contact], StringErrorOutput> {
    private let contactStore: CNContactStore
    private let contactMapper: ContactMapping

    init(contactStore: CNContactStore, contactMapper: ContactMapping) {
        self.contactStore = contactStore
        self.contactMapper = contactMapper
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<[Contact], StringErrorOutput> {
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
        
        return .ok(mappedContacts)
    }
}

extension GetContactsUseCase: GetContactsUseCaseProtocol {}
