//
//  PLTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import CoreDomain
import OpenCombine

public protocol PLTransfersRepository: TransfersRepository {
    func getAccountForDebit() throws -> Result<[AccountRepresentable], Error>
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error>
    func getFinalFee(input: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], Error>
    func checkInternalAccount(input: CheckInternalAccountInput) throws -> Result<CheckInternalAccountRepresentable, Error>
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, Error>
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError>
    func getAccountForDebit() -> AnyPublisher<[AccountRepresentable], Error>
}

public extension PLTransfersRepository {
    func getAccountForDebit() -> AnyPublisher<[AccountRepresentable], Error> {
        return Future { promise in
            do {
                promise(try getAccountForDebit())
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
