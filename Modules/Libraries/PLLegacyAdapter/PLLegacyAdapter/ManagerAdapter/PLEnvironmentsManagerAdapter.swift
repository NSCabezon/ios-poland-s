//
//  PLEnvironmentsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
import SANPLLibrary

public final class PLEnvironmentsManagerAdapter {
    
    private let hostProvider: PLHostProviderProtocol
    private let dataProvider: BSANDataProvider

    public init(bsanHostProvider: PLHostProviderProtocol, dataProvider: BSANDataProvider) {
        self.hostProvider = bsanHostProvider
        self.dataProvider = dataProvider
        self.initEnvironment()
    }
}

extension PLEnvironmentsManagerAdapter: BSANEnvironmentsManager {
    public func getEnvironments() -> BSANResponse<[BSANEnvironmentDTO]> {
        let plEnvironments = hostProvider.getEnvironments()
        let coreEnvironments = getCoreEnvironments(from: plEnvironments)
        return BSANOkResponse(coreEnvironments)
    }
    
    public func getCurrentEnvironment() -> BSANResponse<BSANEnvironmentDTO> {
        if let currentEnvironment = try? dataProvider.getEnvironment() {
            return BSANOkResponse(self.getCoreEnvironment(from: currentEnvironment))
        } else {
            return BSANErrorResponse(nil)
        }
    }
    
    public func setEnvironment(bsanEnvironment: BSANEnvironmentDTO) -> BSANResponse<Void> {
        guard let plEnvironment = try? getPLEnvironment(from: bsanEnvironment) else { return BSANErrorResponse(nil)}
        dataProvider.storeEnviroment(plEnvironment)
        return BSANOkResponse(nil)
    }
    
    public func setEnvironment(bsanEnvironmentName: String) -> BSANResponse<Void> {
        let environments = hostProvider.getEnvironments()
        guard let environment = (environments.first{ $0.name == bsanEnvironmentName }) else { return BSANErrorResponse(nil) }
        dataProvider.storeEnviroment(environment)
        return BSANOkResponse(nil)
    }
}

////MARK: - Private Methods
private extension PLEnvironmentsManagerAdapter {

    func getCoreEnvironments(from plEnvironments: [BSANPLEnvironmentDTO]) -> [BSANEnvironmentDTO] {
        return plEnvironments.map{ plEnvironment in
            self.getCoreEnvironment(from: plEnvironment)
        }
    }

    func getCoreEnvironment(from plEnvironment: BSANPLEnvironmentDTO) -> BSANEnvironmentDTO {
        BSANEnvironmentDTO(urlBase: plEnvironment.urlBase,
                           isHttps: true,
                           name: plEnvironment.name,
                           urlNetInsight: "",
                           urlSocius: "",
                           urlBizumEnrollment: "",
                           urlBizumWeb: nil,
                           urlGetCMC: nil,
                           urlGetNewMagic: nil,
                           urlForgotMagic: nil,
                           urlRestBase: nil,
                           oauthClientId: "",
                           oauthClientSecret: "",
                           microURL: nil,
                           click2CallURL: nil,
                           branchLocatorGlobile: nil,
                           insurancesPass2Url: nil,
                           pass2oauthClientId: "",
                           pass2oauthClientSecret: "",
                           ecommerceUrl: "",
                           fintechUrl: "")
    }

    func getPLEnvironment(from coreEnvironment: BSANEnvironmentDTO) throws -> BSANPLEnvironmentDTO {

        return try BSANPLEnvironmentDTO(name: coreEnvironment.name,
                                        blikAuthBaseUrl: "", //TODO: - Add blikAuthBaseUrl in to the core environment object
                                        urlBase: coreEnvironment.urlBase,
                                        clientId: dataProvider.getEnvironment().clientId)
    }

    func initEnvironment() {
        self.dataProvider.storeEnviroment(self.hostProvider.environmentDefault)
    }
}
