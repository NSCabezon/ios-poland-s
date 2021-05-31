//
//  BSANDataProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import DataRepository
import SANLegacyLibrary

public class BSANDataProvider {
    
    private var dataRepository: DataRepository
    
    public init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
    
    public func storeEnviroment(_ enviroment: BSANPLEnvironmentDTO) {
        objc_sync_enter(dataRepository)
        dataRepository.store(enviroment)
        objc_sync_exit(dataRepository)
    }
    
    public func getEnvironment() throws -> BSANPLEnvironmentDTO {
        if let bsanEnvironmentDTO = dataRepository.get(BSANPLEnvironmentDTO.self) {
            return bsanEnvironmentDTO
        }
        throw BSANIllegalStateException("BSANEnvironment is nil in DataRepository")
    }
    
    // TODO: Fill with AuthModel
    public func getAuthCredentials() throws -> String {
        throw BSANIllegalStateException("AuthCredentials nil in DataRepository")
    }

    public func setDemoMode(_ isDemo: Bool, _ demoUser: String?) {
        if isDemo, let demoUser = demoUser {
            objc_sync_enter(dataRepository)
            dataRepository.store(DemoMode(demoUser))
            objc_sync_exit(dataRepository)
        } else {
            dataRepository.remove(DemoMode.self)
        }
    }
    
    public func isDemo() -> Bool {
        return dataRepository.get(DemoMode.self) != nil
    }

    // MARK: Login public key store management
    public func storePublicKey(_ pubKey: PubKeyDTO) {
        objc_sync_enter(dataRepository)
        dataRepository.store(pubKey)
        objc_sync_exit(dataRepository)
    }

    public func getPublicKey() throws -> PubKeyDTO {
        if let pubKeyDTO = dataRepository.get(PubKeyDTO.self) {
            return pubKeyDTO
        }
        throw BSANIllegalStateException("PubKeyDTO is nil in DataRepository")
    }

    public func removePublicKey() {
        self.dataRepository.remove(PubKeyDTO.self)
    }
}

extension BSANDataProvider: BSANDemoProviderProtocol {
    
    public func getDemoMode() -> DemoMode? {
        return dataRepository.get(DemoMode.self)
    }
}
