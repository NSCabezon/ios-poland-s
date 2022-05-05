//
//  PLGetUsernameUseCase.swift
//  Santander
//
//  Created by alvola on 19/4/22.
//

import Foundation
import PersonalArea
import OpenCombine
import CoreFoundationLib
import CoreDomain

struct PLGetUsernameUseCase: GetUsernameUseCase {
    
    private let globalPositionRepository: GlobalPositionDataRepository
    private let oldDependencies: DependenciesResolver
    
    init(dependencies: PersonalAreaExternalDependenciesResolver) {
        self.oldDependencies = dependencies.resolve()
        self.globalPositionRepository = dependencies.resolve()
    }
    
    func fetchUsernamePublisher() -> AnyPublisher<String?, Never> {
        return globalPositionRepository
            .getGlobalPosition()
            .map(getName)
            .eraseToAnyPublisher()
    }
}

private extension PLGetUsernameUseCase {
    func getName(_ globalPosition: GlobalPositionDataRepresentable) -> String {
        let name = globalPosition.clientNameWithoutSurname
        let secondName = globalPosition.clientFirstSurnameRepresentable
        let surname = globalPosition.clientSecondSurnameRepresentable
        return concat(strings: [name, secondName, surname])
    }
    
    func concat(strings: [String?]) -> String {
        var string = ""
        strings.enumerated().forEach({
            guard let str = $1, !str.isEmpty else { return }
            if $0 > 0 { string += " " }
            string += str
        })
        return string
    }
}
