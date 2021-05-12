//
//  PTNetworkProvider.swift
//  SANPTLibrary
//
//  Created by Luis Escámez Sánchez on 17/03/2021.
//

import Foundation
import SANLibraryV3

public final class PLNetworkProvider {
//    private let dataProvider: BSANDataProvider
//    private let networkProvider: NetworkProvider
//    private var demoNetworkProvider: NetworkProvider
    private var isDemoUser: Bool {
//        return dataProvider.isDemo()
        return true
    }
    
//    public init(dataProvider: BSANDataProvider, demoInterpreter: DemoUserProtocol) {
    public init(demoInterpreter: DemoUserProtocol) {
//        self.dataProvider = dataProvider
//        self.networkProvider = URLSessionNetworkProvider(dataProvider: dataProvider)
//        self.demoNetworkProvider = BSANLocalManager(demoInterpreter: demoInterpreter)
    }
}

extension PLNetworkProvider: NetworkProvider {
    public func request<Request, Response>(_ request: Request) -> Result<Response, NetworkProviderError> where Request : NetworkProviderRequest, Response : Decodable {
//        if !isDemoUser {
//            return networkProvider.request(request)
//        } else {
//            return demoNetworkProvider.request(request)
//        }
        return .failure(.other)
    }
    
    public func requestData<Request>(_ request: Request) -> Result<Data, NetworkProviderError> where Request : NetworkProviderRequest {
//        if !isDemoUser {
//            return networkProvider.requestData(request)
//        } else {
//            return demoNetworkProvider.requestData(request)
//        }
        return .failure(.other)
    }
    
    public func requestDataWithHeaders<Request>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> where Request : NetworkProviderRequest {
//        if !isDemoUser {
//            return networkProvider.requestDataWithHeaders(request)
//        } else {
//            return demoNetworkProvider.requestDataWithHeaders(request)
//        }
        return .failure(.other)
    }
}
