//
//  PLEnvironmentsManager.swift
//  SANPLLibrary

import Foundation

public protocol PLEnvironmentsManagerProtocol {
    func getEnvironments() -> Result<[BSANPLEnvironmentDTO], Error>
    func getCurrentEnvironment() -> Result<BSANPLEnvironmentDTO, Error>
    func setEnvironment(bsanEnvironment: BSANPLEnvironmentDTO) -> Result<Void, Error>
    func setEnvironment(bsanEnvironmentName: String) -> Result<Void, Error>
}

public enum EnvironmentsManagerError: Error {
    case environmentNotFound
    case environmentsNotFound
}

final class PLEnvironmentsManager {
    private let hostProvider: PLHostProviderProtocol
    private let bsanDataProvider: BSANDataProvider

    init(bsanDataProvider: BSANDataProvider, hostProvider: PLHostProviderProtocol) {
        self.hostProvider = hostProvider
        self.bsanDataProvider = bsanDataProvider
        self.initEnvironment()
    }
}

// MARK: - Private Methods

private extension PLEnvironmentsManager {
    func initEnvironment() {
        self.bsanDataProvider.storeEnviroment(self.hostProvider.environmentDefault)
    }
}

// MARK: - PLEnvironmentsManagerProtocol

extension PLEnvironmentsManager: PLEnvironmentsManagerProtocol {
    public func getEnvironments() -> Result<[BSANPLEnvironmentDTO], Error> {
        return .success(self.hostProvider.getEnvironments())
    }

    public func getCurrentEnvironment() ->  Result<BSANPLEnvironmentDTO, Error> {
        guard let environment = try? self.bsanDataProvider.getEnvironment() else {
            return .failure(EnvironmentsManagerError.environmentNotFound)
        }
        return .success(environment)
    }

    public func setEnvironment(bsanEnvironment: BSANPLEnvironmentDTO) -> Result<Void, Error> {
        self.bsanDataProvider.storeEnviroment(bsanEnvironment)
        return .success(())
    }

    public func setEnvironment(bsanEnvironmentName: String) -> Result<Void, Error> {
        guard let bsanEnvironment = self.hostProvider.getEnvironments().first(where: { $0.name == bsanEnvironmentName }) else {
            return .failure(EnvironmentsManagerError.environmentNotFound)
        }
        _ = self.setEnvironment(bsanEnvironment: bsanEnvironment)
        return .success(())
    }
}
