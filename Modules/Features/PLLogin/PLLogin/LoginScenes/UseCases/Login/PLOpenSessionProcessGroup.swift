//
//  PLOpenSessionProcessGroup.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 4/11/21.
//

import CoreFoundationLib
import PLCommons
import CoreDomain
import PLCommons
import Commons

final class PLOpenSessionProcessGroup: ProcessGroup<Void, PLOpenSessionProcessGroupOutput, PLOpenSessionProcessGroupError> {

    private var sessionUseCase: PLSessionUseCase {
        self.dependenciesEngine.resolve(for: PLSessionUseCase.self)
    }

    private var globalPositionOptionUseCase: PLGetGlobalPositionOptionUseCase {
        return self.dependenciesEngine.resolve(for: PLGetGlobalPositionOptionUseCase.self)
    }

    override func registerDependencies() {
        self.dependenciesEngine.register(for: PLSessionUseCase.self) { resolver in
            return PLSessionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLGetGlobalPositionOptionUseCase.self) { resolver in
            return PLGetGlobalPositionOptionUseCase(dependenciesResolver: resolver)
        }
    }

    private lazy var sessionDataManager: SessionDataManager = {
        let manager = self.dependenciesEngine.resolve(for: SessionDataManager.self)
        manager.setDataManagerProcessDelegate(self)
        return manager
    }()

    private var onContinue: ((Result<PLOpenSessionProcessGroupOutput, PLOpenSessionProcessGroupError>) -> Void)?
    private var globalPositionScene: GlobalPositionOptionEntity = .classic
    private var userId: String?

    override func execute(completion: @escaping (Result<PLOpenSessionProcessGroupOutput, PLOpenSessionProcessGroupError>) -> Void) {
        self.onContinue = completion
        Scenario(useCase: self.sessionUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .then(scenario: { [weak self] _ -> Scenario<Void, GetGlobalPositionOptionUseCaseOkOutput, PLUseCaseErrorOutput<LoginErrorType>>? in
                guard let self = self else { return nil }
                return Scenario(useCase: self.globalPositionOptionUseCase)
            })
            .onSuccess( { [weak self] output in
                self?.globalPositionScene = output.globalPositionOption
                self?.userId = output.userId
            })
            .finally( { [weak self] in
                self?.sessionDataManager.load()
            })
    }
}

extension PLOpenSessionProcessGroup: SessionDataManagerProcessDelegate {
    func handleProcessEvent(_ event: SessionManagerProcessEvent) {
        switch event {
        case .loadDataSuccess, .fail(_):
            self.onContinue?(.success(PLOpenSessionProcessGroupOutput(globalPositionOption: self.globalPositionScene, userId: self.userId)))
            self.onContinue = nil
        default:
            break
        }
    }
}

struct PLOpenSessionProcessGroupOutput {
    let globalPositionOption: GlobalPositionOptionEntity
    let userId: String?
}

struct PLOpenSessionProcessGroupError: Error {}
