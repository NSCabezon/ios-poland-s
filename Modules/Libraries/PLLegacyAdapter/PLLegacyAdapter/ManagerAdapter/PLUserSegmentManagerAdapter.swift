//
//  PLUserSegmentManagerAdapter.swift
//  PLLegacyAdapter
//
//  Created by Marcos Álvarez 11/05/2021
//

import SANLegacyLibrary

public final class PLUserSegmentManagerAdapter {}

extension PLUserSegmentManagerAdapter: BSANUserSegmentManager {
    public func getUserSegment() throws -> BSANResponse<UserSegmentDTO> {
        return BSANOkResponse(UserSegmentDTO())
    }
    
    public func loadUserSegment() throws -> BSANResponse<UserSegmentDTO> {
        return BSANOkResponse(UserSegmentDTO())
    }
    
    public func saveIsSelectUSer(_ isSelect: Bool) {}
    
    public func isSelectUser() throws -> Bool {
        return false
    }
    
    public func saveIsSmartUser(_ isSmart: Bool) {}
    
    public func isSmartUser() throws -> Bool {
        return false
    }
}
