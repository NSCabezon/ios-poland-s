//
//  PLOpenSessionProcessGroup.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 4/11/21.
//

import DomainCommon
import Commons
import PLCommons
import Models

final class PLOpenSessionProcessGroup: ProcessGroup<Void, PLOpenSessionProcessGroupOutput, PLOpenSessionProcessGroupError> {

    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesResolver.resolve(for: PLSessionUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesResolver.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    override func execute(completion: @escaping (Result<PLOpenSessionProcessGroupOutput, PLOpenSessionProcessGroupError>) -> Void) {
        Scenario(useCase: self.sessionUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .then(scenario: { [weak self] _ -> Scenario<Void, GetGlobalPositionOptionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.globalPositionOptionUseCase)
            })
            .onSuccess( { output in
                completion(.success(PLOpenSessionProcessGroupOutput(globalPositionOption: output.globalPositionOption,
                                                                    userId: output.userId)))
            })
            .onError { _ in
                completion(.failure(PLOpenSessionProcessGroupError()))
            }
    }
}


struct PLOpenSessionProcessGroupOutput {
    let globalPositionOption: GlobalPositionOptionEntity
    let userId: String?
}

struct PLOpenSessionProcessGroupError: Error {}
