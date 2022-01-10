//
//  PLWebViewLinkRepositoryProtocol.swift
//  PLCommons
//

import Foundation
import Commons

public struct PLWebViewLink {
    public init(id: String, url: String, method: HTTPMethodType, isAvailable: Bool) {
        self.id = id
        self.url = url
        self.method = method
        self.isAvailable = isAvailable
    }
    
    public let id: String
    public let url: String
    public let method: HTTPMethodType
    public let isAvailable: Bool
}

public enum PLWebViewLinkRepositoryGroup {
    case accounts
    case cards
    case helpCenter
}

public protocol PLWebViewLinkRepositoryProtocol {
    func getWebViewLink(forIdentifier identifier: String) -> PLWebViewLink?
    func getWebViewLink(forIdentifier identifier: String, fromGroups groups: [PLWebViewLinkRepositoryGroup]) -> PLWebViewLink?
}
