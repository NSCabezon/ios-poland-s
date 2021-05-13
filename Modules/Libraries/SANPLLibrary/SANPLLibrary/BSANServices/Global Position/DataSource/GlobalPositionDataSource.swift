//
//  GlobalPositionDataSource.swift
//  SANPLLibrary
//
//  Created by Rodrigo Jurado on 13/5/21.
//

import Foundation

protocol GlobalPositionDataSource {
    func getAccounts() throws -> Result<GlobalPositionDTO, NetworkProviderError>
}
