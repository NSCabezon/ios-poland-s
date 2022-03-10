//
//  PLPrivateMenuGetNameUseCase.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 8/3/22.
//

import OpenCombine
import CoreDomain
import CoreFoundationLib
import PrivateMenu

struct PLPrivateMenuGetNameUseCase {
    private let globalPositionRepository: GlobalPositionDataRepository
    
    init(dependencies: PrivateMenuExternalDependenciesResolver) {
        globalPositionRepository = dependencies.resolve()
    }
}

extension PLPrivateMenuGetNameUseCase: GetNameUseCase {
    func fetchNameOrAlias() -> AnyPublisher<NameRepresentable, Never> {
        return globalPositionRepository
            .getGlobalPosition()
            .map { globalPosition -> NameRepresentable in
                let name = globalPosition.clientNameWithoutSurname ?? ""
                let surname = globalPosition.clientSecondSurnameRepresentable ?? ""
                return Name(
                    availableName: name + " " + surname,
                    initials: "\(name.prefix(1))\(surname.prefix(1))"
                )
            }
            .eraseToAnyPublisher()
    }
}

private extension PLPrivateMenuGetNameUseCase {
    struct Name: NameRepresentable {
        var name: String?
        var availableName: String?
        var fullName: String?
        var initials: String?
        
        init(availableName: String, initials: String) {
            self.availableName = availableName
            self.initials = initials
        }
    }
}
