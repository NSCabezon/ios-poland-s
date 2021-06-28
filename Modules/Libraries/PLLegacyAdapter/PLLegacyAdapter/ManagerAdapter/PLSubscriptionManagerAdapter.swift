//
//  PLSubscriptionManagerManagerAdapter.swift
//  PLLegacyAdapter

import SANLegacyLibrary

final class PLSubscriptionManagerAdapter {}

extension PLSubscriptionManagerAdapter: BSANSubscriptionManager {
    func activate(token: String, instaID: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }

    func deactivate(token: String, instaID: String) throws -> BSANResponse<Void> {
        return BSANErrorResponse(nil)
    }
}
