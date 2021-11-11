//
//  PLOneAuthorizationProcessorRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 5/11/21.
//

import CoreDomain

public protocol PLOneAuthorizationProcessorRepository: OneAuthorizationProcessorRepository {
    func confirmPin(authorizationId: String, parameters: ConfirmChallengeParameters) throws -> Result<Void, Error>
}
