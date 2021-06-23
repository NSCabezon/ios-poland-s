//
//  LoginEnvironmentLayer.swift
//  PLLogin

import Foundation
import Commons
import Models
import Foundation
import DomainCommon
import SANPLLibrary
import Commons
import Repository
import Models

protocol LoginEnvironmentLayerDelegate: class {
    func didLoadEnvironment(_ environment: PLEnvironmentEntity, publicFilesEnvironment: PublicFilesEnvironmentEntity)
}

final class LoginEnvironmentLayer {
    private let dependenciesResolver: DependenciesResolver
    private weak var delegate: LoginEnvironmentLayerDelegate?

    private var getPLCurrentEnvironmentUseCase: GetPLCurrentEnvironmentUseCase {
        self.dependenciesResolver.resolve(for: GetPLCurrentEnvironmentUseCase.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func setDelegate(_ delegate: LoginEnvironmentLayerDelegate) {
        self.delegate = delegate
    }

    func getCurrentEnvironments() {
        MainThreadUseCaseWrapper(
            with: self.getPLCurrentEnvironmentUseCase,
            onSuccess: { [weak self] result in
                   self?.delegate?.didLoadEnvironment(
                    result.bsanEnvironment,
                    publicFilesEnvironment: result.publicFilesEnvironment
                )
        })
    }
}

