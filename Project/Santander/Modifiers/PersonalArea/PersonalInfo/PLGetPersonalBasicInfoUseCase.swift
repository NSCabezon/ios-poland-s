//
//  PLGetPersonalBasicInfoUseCase.swift
//  Santander
//
//  Created by Rubén Muñoz López on 20/8/21.
//

import PersonalArea
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

final class PLGetPersonalBasicInfoUseCase: UseCase<Void, GetPersonalBasicInfoUseCaseOkOutput, StringErrorOutput> {
    private let dependencies: DependenciesResolver
    private lazy var provider: PLManagersProviderProtocol = {
        dependencies.resolve(for: PLManagersProviderProtocol.self)
    }()
    
    init(dependencies: DependenciesResolver) {
        self.dependencies = dependencies
    }
    
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<GetPersonalBasicInfoUseCaseOkOutput, StringErrorOutput> {
        let result = try provider.getCustomerManager().getIndividual()
        switch result {
        case .success(let response):
            return .ok(GetPersonalBasicInfoUseCaseOkOutput(personalInformation: basicInfoRepresentableToEntity(response)))
        case .failure(let error):
            return .error(StringErrorOutput(error.localizedDescription))
        }
    }
}

extension PLGetPersonalBasicInfoUseCase: GetPersonalBasicInfoUseCaseProtocol { }

private extension PLGetPersonalBasicInfoUseCase {
    func basicInfoRepresentableToEntity(_ representable: PersonalBasicInfoRepresentable) -> PersonalInformationEntity {
        var dto = PersonBasicDataDTO(mainAddress: representable.mainAddress,
                                     addressNodes: representable.addressNodes,
                                     documentType: representable.documentType,
                                     documentNumber: representable.documentNumber,
                                     birthDate: representable.birthdayDate,
                                     birthString: representable.birthString,
                                     phoneNumber: representable.phoneNumber,
                                     contactHourFrom: representable.contactHourFrom,
                                     contactHourTo: representable.contactHourTo,
                                     email: representable.email,
                                     emailAlternative: localized("personalArea_text_uninformed"))
        dto.smsPhoneNumber = representable.smsPhoneNumber
        dto.correspondenceAddressNodes = representable.correspondenceAddressNodes
        return PersonalInformationEntity(dto)
    }
}
