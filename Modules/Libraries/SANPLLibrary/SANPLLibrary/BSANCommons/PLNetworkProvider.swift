//
//  PLNetworkProvider.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

public final class PLNetworkProvider {
    private let dataProvider: BSANDataProvider
    private let networkProvider: NetworkProvider
    private var demoNetworkProvider: NetworkProvider
    private var demoInterpreter: DemoUserProtocol
    private var isDemoUser: Bool {
        return dataProvider.isDemo() && self.demoInterpreter.isDemoModeAvailable
    }

    public init(
        dataProvider: BSANDataProvider,
        demoInterpreter: DemoUserProtocol,
        isTrustInvalidCertificateEnabled: Bool,
        trustedHeadersProvider: PLTrustedHeadersGenerable
    ) {
        self.dataProvider = dataProvider
        self.networkProvider = URLSessionNetworkProvider(
            dataProvider: dataProvider,
            isTrustInvalidCertificateEnabled: isTrustInvalidCertificateEnabled,
            trustedHeadersProvider: trustedHeadersProvider
        )
        self.demoNetworkProvider = BSANLocalManager(demoInterpreter: demoInterpreter)
        self.demoInterpreter = demoInterpreter
    }
}

extension PLNetworkProvider: NetworkProvider {
    public func request<Request, Response>(_ request: Request) -> Result<Response, NetworkProviderError> where Request : NetworkProviderRequest, Response : Decodable {
        if !isDemoUser {
            return networkProvider.request(request)
        } else {
            return demoNetworkProvider.request(request)
        }
    }
    
    public func request<Request>(_ request: Request) -> Result<Void, NetworkProviderError> where Request : NetworkProviderRequest {
        if !isDemoUser {
            return networkProvider.request(request)
        } else {
            return demoNetworkProvider.request(request)
        }
    }

    public func requestData<Request>(_ request: Request) -> Result<Data, NetworkProviderError> where Request : NetworkProviderRequest {
        if !isDemoUser {
            return networkProvider.requestData(request)
        } else {
            return demoNetworkProvider.requestData(request)
        }
    }

    public func requestDataWithHeaders<Request>(_ request: Request) -> Result<NetworkProviderResponseWithHeaders, NetworkProviderError> where Request : NetworkProviderRequest {
        if !isDemoUser {
            return networkProvider.requestDataWithHeaders(request)
        } else {
            return demoNetworkProvider.requestDataWithHeaders(request)
        }
    }
    
    public func requestDataWithStatus<Request>(_ request: Request) -> Result<NetworkProviderResponseWithStatus, NetworkProviderError> where Request : NetworkProviderRequest {
        if !isDemoUser {
            return networkProvider.requestDataWithStatus(request)
        } else {
            return demoNetworkProvider.requestDataWithStatus(request)
        }
    }
}
