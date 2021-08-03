//
//  PLSubscriptionManagerManagerAdapter.swift
//  PLLegacyAdapter

import SANLegacyLibrary

final class PLSubscriptionManagerAdapter {}

extension PLSubscriptionManagerAdapter: BSANSubscriptionManager {
    func activate(magicPhrase token: String, instaID: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }

    func deactivate(magicPhrase token: String, instaID: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}
