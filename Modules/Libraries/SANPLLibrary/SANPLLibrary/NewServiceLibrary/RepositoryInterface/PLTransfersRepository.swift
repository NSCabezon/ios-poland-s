//
//  PLTransfersRepository.swift
//  SANPLLibrary
//
//  Created by Jose Javier Montes Romero on 6/10/21.
//

import OpenCombine
import CoreDomain

public protocol PLTransfersRepository: TransfersRepository {
    func getAccountsForDebit() throws -> Result<[AccountRepresentable], Error>
    func getAccountsForCredit() throws -> Result<[AccountRepresentable], Error>
    func checkTransactionAvailability(input: CheckTransactionAvailabilityInput) throws -> Result<CheckTransactionAvailabilityRepresentable, Error>
    func getFinalFee(input: CheckFinalFeeInput) throws -> Result<[CheckFinalFeeRepresentable], Error>
    func checkInternalAccount(input: CheckInternalAccountInput) throws -> Result<CheckInternalAccountRepresentable, Error>
    func getChallenge(parameters: GenericSendMoneyConfirmationInput) throws -> Result<SendMoneyChallengeRepresentable, NetworkProviderError>
    func notifyDevice(_ parameters: NotifyDeviceInput) throws -> Result<AuthorizationIdRepresentable, NetworkProviderError>
    func getAccountsForDebit() -> AnyPublisher<[AccountRepresentable], Error>
    func getAccountsForCredit() -> AnyPublisher<[AccountRepresentable], Error>
}

public extension PLTransfersRepository {
    func getAccountsForDebit() -> AnyPublisher<[AccountRepresentable], Error> {
        return Future { promise in
            do {
                promise(try getAccountsForDebit())
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAccountsForCredit() -> AnyPublisher<[AccountRepresentable], Error> {
        return Future { promise in
            do {
                promise(try getAccountsForCredit())
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
