//
//  PLEnvironmentsManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary
//import SANPTLibrary

final class PLEnvironmentsManagerAdapter {
    
//    private let hostProvider: PTHostProviderProtocol
//    private let dataProvider: BSANDataProvider
//
//    public init(bsanHostProvider: PTHostProviderProtocol, dataProvider: BSANDataProvider) {
//        self.hostProvider = bsanHostProvider
//        self.dataProvider = dataProvider
//    }
}

extension PLEnvironmentsManagerAdapter: BSANEnvironmentsManager {
    func getEnvironments() -> BSANResponse<[BSANEnvironmentDTO]> {
//        let ptEnvironments = hostProvider.getEnvironments()
//        let coreEnvironments = getCoreEnvironments(from: ptEnvironments)
//        return BSANOkResponse(coreEnvironments)
        return BSANErrorResponse(nil)
    }
    
    func getCurrentEnvironment() -> BSANResponse<BSANEnvironmentDTO> {
//        if let currentEnvironment = try? dataProvider.getEnvironment() {
//            return BSANOkResponse(self.getCoreEnvironment(from: currentEnvironment))
//        } else {
//            return BSANErrorResponse(nil)
//        }
        return BSANErrorResponse(nil)
    }
    
    func setEnvironment(bsanEnvironment: BSANEnvironmentDTO) -> BSANResponse<Void> {
//        guard let ptEnvironment = try? getPTEnvironment(from: bsanEnvironment) else { return BSANErrorResponse(nil)}
//        dataProvider.storeEnviroment(ptEnvironment)
        return BSANOkResponse(nil)
    }
    
    func setEnvironment(bsanEnvironmentName: String) -> BSANResponse<Void> {
//        let environments = hostProvider.getEnvironments()
//        guard let environment = (environments.first{ $0.name == bsanEnvironmentName }) else { return BSANErrorResponse(nil) }
//        dataProvider.storeEnviroment(environment)
        return BSANOkResponse(nil)
    }
}

////MARK: - Private Methods
//private extension PTEnvironmentsManagerApadater {
//    
//    func getCoreEnvironments(from ptEnvironments: [BSANPTEnvironmentDTO]) -> [BSANEnvironmentDTO] {
//        return ptEnvironments.map{ ptEnvironment in
//            self.getCoreEnvironment(from: ptEnvironment)
//        }
//    }
//    
//    func getCoreEnvironment(from ptEnvironment: BSANPTEnvironmentDTO) -> BSANEnvironmentDTO {
//        BSANEnvironmentDTO(urlBase: ptEnvironment.urlBase,
//                           isHttps: ptEnvironment.isHttps,
//                           name: ptEnvironment.name,
//                           urlNetInsight: "",
//                           urlSocius: ptEnvironment.urlNewRegistration,
//                           urlBizumEnrollment: "",
//                           urlBizumWeb: nil,
//                           urlGetCMC: nil,
//                           urlGetNewPassword: nil,
//                           urlForgotPassword: nil,
//                           urlRestBase: nil,
//                           oauthClientId: "",
//                           oauthClientSecret: "",
//                           microURL: nil,
//                           click2CallURL: nil,
//                           branchLocatorGlobile: nil,
//                           insurancesPass2Url: nil,
//                           pass2oauthClientId: "",
//                           pass2oauthClientSecret: "",
//                           ecommerceUrl: "")
//    }
//    
//    func getPTEnvironment(from coreEnvironment: BSANEnvironmentDTO) throws -> BSANPTEnvironmentDTO {
//        return try BSANPTEnvironmentDTO(isHttps: coreEnvironment.isHttps,
//                                        name: coreEnvironment.name,
//                                        urlBase: coreEnvironment.urlBase,
//                                        clientId: dataProvider.getEnvironment().clientId,
//                                        urlNewRegistration: coreEnvironment.urlSocius)
//    }
//}
