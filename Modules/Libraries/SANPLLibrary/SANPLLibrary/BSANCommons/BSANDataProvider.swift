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

    public func createSessionData(_ userDTO: UserDTO) {
        let sessionData = SessionData(userDTO)
        objc_sync_enter(dataRepository)
        dataRepository.store(sessionData)
        objc_sync_exit(dataRepository)
    }

    public func cleanSessionData() throws {
        let sessionData = try self.getSessionData()
        let userDTO = sessionData.loggedUserDTO
        self.dataRepository.remove(SessionData.self)
        self.createSessionData(userDTO)
    }

    public func getSessionData() throws -> SessionData {
        if let sessionData = dataRepository.get(SessionData.self) {
            return sessionData
        }
        throw BSANIllegalStateException("SessionData nil in DataRepository")
    }

    public func updateSessionData(_ sessionData: SessionData) {
        objc_sync_enter(dataRepository)
        dataRepository.store(sessionData)
        objc_sync_exit(dataRepository)
    }

    public func store(_ newGlobalPositionDTO: GlobalPositionDTO) {
        objc_sync_enter(dataRepository)
        if let sessionData = try? getSessionData() {
            sessionData.globalPositionDTO = newGlobalPositionDTO
            updateSessionData(sessionData)
        }
        objc_sync_exit(dataRepository)
    }
}

extension BSANDataProvider: BSANDemoProviderProtocol {
    
    public func getDemoMode() -> DemoMode? {
        return dataRepository.get(DemoMode.self)
    }
}
