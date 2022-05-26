//
//  PLGetAccountsFullNameUseCase.swift
//  Santander
//
//  Created by Carlos Monfort Gómez on 17/5/22.
//

import Foundation
import SANPLLibrary
import OpenCombine
import TransferOperatives
import CoreDomain

struct PLGetAccountsFullNameUseCase {
    let transfersRepository: PLTransfersRepository
    
    init(dependencies: PLInternalTransferOperativeExternalDependenciesResolver) {
        self.transfersRepository = dependencies.resolve()
    }
}

extension PLGetAccountsFullNameUseCase: GetAccountsFullNameUseCase {
    func fetchAccountsFullName(_ account: AccountRepresentable) -> AnyPublisher<GetAccountsFullNameUseCaseOutput, Error> {
        let checkDigits = account.ibanRepresentable?.checkDigits ?? ""
        let bban = account.ibanRepresentable?.codBban ?? ""
        return transfersRepository.getAccountDetail(GetPLAccountDetailInput(accountNumber: checkDigits + bban))
            .map({ account in
                return self.getName(account)
            })
            .eraseToAnyPublisher()
    }
}

private extension PLGetAccountsFullNameUseCase {
    func getName(_ accountDetail: PLAccountDetailRepresentable) -> GetAccountsFullNameUseCaseOutput {
        let name = accountDetail.ownerRepresentable?.customerName?.camelCasedString
        return GetAccountsFullNameUseCaseOutput(fullName: name)
    }
}
