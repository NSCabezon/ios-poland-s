//
//  PLWebViewLinkRepository.swift
//  Santander
//
//  Created by 186493 on 28/10/2021.
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import PLCommons

struct PLWebViewLinkRepository: PLWebViewLinkRepositoryProtocol {
    
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func getWebViewLink(forIdentifier identifier: String) -> PLWebViewLink? {
        getWebViewLink(forIdentifier: identifier, fromGroups: [.cards, .accounts, .helpCenter])
    }
    
    func getWebViewLink(forIdentifier identifier: String, fromGroups groups: [PLWebViewLinkRepositoryGroup]) -> PLWebViewLink? {
        let repository = self.dependenciesResolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)
        guard let repositoryGetter = repository.get() else { return nil }
        let options = Array(
            groups.compactMap { group -> [PLAccountOtherOperativesDTO]? in
                switch group {
                case .cards: return repositoryGetter.cardsOptions
                case .accounts: return repositoryGetter.accountsOptions
                case .helpCenter: return repositoryGetter.helpCenterOptions
                }
            }.joined())
        guard let option = options.first(where: { $0.id == identifier }) else { return nil }
        return map(otherOperative: option)
    }
    
    private func map(otherOperative: PLAccountOtherOperativesDTO) -> PLWebViewLink? {
        guard let id = otherOperative.id,
              let url = otherOperative.url,
              let methodString = otherOperative.method,
              let method = HTTPMethodType(rawValue: methodString.uppercased()),
              let isAvailable = otherOperative.isAvailable
        else { return nil }
        return PLWebViewLink(id: id, url: url, method: method, isAvailable: isAvailable)
    }
}
