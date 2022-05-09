//
//  FundReactiveDataRepository.swift
//  CoreDomain
//
//  Created by Ernesto Fernandez Calles on 15/3/22.
//

import Foundation
import CoreDomain
import OpenCombine
import CoreFoundationLib
import SANLegacyLibrary

final class FundReactiveDataRepository {
    private let fundDataSource: FundDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider
    private let oldResolver: DependenciesResolver

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider, oldResolver: DependenciesResolver) {
        self.fundDataSource = FundDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
        self.oldResolver = oldResolver
    }
}

extension FundReactiveDataRepository: FundReactiveRepository {
    func loadDetail(fund: FundRepresentable) -> AnyPublisher<FundDetailRepresentable, Error> {
        Future<FundDetailRepresentable, Error> { promise in
            Async(queue: .global(qos: .background)) {
                do {
                    let fundDetails = try self.getDetails(fund: fund).get()
                    promise(.success(fundDetails))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func loadMovements(fund: FundRepresentable, pagination: PaginationRepresentable?, filters: TransactionFiltersRepresentable?) -> AnyPublisher<FundMovementListRepresentable, Error> {
        Future<FundMovementListRepresentable, Error> { promise in
            Async(queue: .global(qos: .background)) {
                do {
                    let fundMovements = try self.getMovements(fund: fund, pagination: pagination, filters: filters).get()
                    promise(.success(fundMovements))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func loadMovementDetails(fund: FundRepresentable, movement: FundMovementRepresentable) -> AnyPublisher<FundMovementDetailRepresentable?, Error> {
        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

private extension FundReactiveDataRepository {
    func getDetails(fund: FundRepresentable) throws -> Result<FundDetailsDTO, NetworkProviderError> {
        guard let fundDTO = fund as? SANLegacyLibrary.FundDTO, let fundNumber = fundDTO.accountId?.id else {
            throw SomeError()
        }
        if let cachedDetail = self.getCachedDetail(fundNumber) {
            return .success(cachedDetail)
        }
        let result = self.fundDataSource.getFundDetails(registerId: fundNumber)
        self.processDetailResult(fundNumber, result: result)
        return result
    }

    func getCachedDetail(_ fundNumber: String) -> FundDetailsDTO? {
        return self.bsanDataProvider.getFundDetail(withFundId: fundNumber)
    }

    func processDetailResult(_ fundNumber: String, result: Result<FundDetailsDTO, NetworkProviderError>) {
        if case .success(let fundDetail) = result {
            self.bsanDataProvider.store(fundDetail: fundDetail, forFundId: fundNumber)
        }
    }

    func getMovements(fund: FundRepresentable, pagination: PaginationRepresentable?, filters: TransactionFiltersRepresentable?) throws -> Result<FundTransactionListDTO, NetworkProviderError> {
        guard let fundDTO = fund as? SANLegacyLibrary.FundDTO, let fundNumber = fundDTO.accountId?.id else {
            throw SomeError()
        }
        let startDate = filters?.dateInterval?.start.stringWithDateFormat(TimeFormat.yyyyMMdd.rawValue)
        let endDate = filters?.dateInterval?.end.stringWithDateFormat(TimeFormat.yyyyMMdd.rawValue)
        var filtersParameters = FundTransactionsParameters(dateFrom: startDate, dateTo: endDate, skipNumber: nil, operationCount: 25)
        let cachedMovements = filters.isNil ? self.getCachedMovements(fundNumber) : self.getCachedFilteredMovements(fundNumber, filter: filtersParameters)
        if let cachedMovements = cachedMovements, pagination.isNil {
            return .success(cachedMovements)
        }
        if let paginationDTO = pagination as? PaginationDTO, paginationDTO.endList == true {
            return .success(FundTransactionListDTO(entries: [], more: false))
        }
        let skipNumber = cachedMovements?.entries?.count ?? 0
        filtersParameters.skipNumber = skipNumber
        let languageType = self.oldResolver.resolve(forOptionalType: StringLoader.self)?.getCurrentLanguage().languageType ?? .polish
        let language = languageType.rawValue.uppercased()
        let result = self.fundDataSource.getFundTransactionsFiltered(registerId: fundNumber, language: language, parameters: filtersParameters)
        filters.isNil ?
        self.processMovementsResult(fundNumber, result: result) :
        self.processFilteredMovementsResult(fundNumber, filter: filtersParameters, result: result)
        return result
    }

    func getCachedMovements(_ fundNumber: String) -> FundTransactionListDTO? {
        guard let movements = self.bsanDataProvider.getFundMovements(withFundId: fundNumber),
              let more = self.bsanDataProvider.getFundMoreMovements(withFundId: fundNumber) else { return nil }
        return FundTransactionListDTO(entries: movements, more: more)
    }

    func getCachedFilteredMovements(_ fundNumber: String, filter: FundTransactionsParameters) -> FundTransactionListDTO? {
        guard let movements = self.bsanDataProvider.getFundFilteredMovements(withFundId: fundNumber, andFilter: filter),
              let more = self.bsanDataProvider.getFundMoreMovements(withFundId: fundNumber, andFilter: filter) else { return nil }
        return FundTransactionListDTO(entries: movements, more: more)
    }

    func processMovementsResult(_ fundNumber: String, result: Result<FundTransactionListDTO, NetworkProviderError>) {
        if case .success(let fundTransactionList) = result {
            self.bsanDataProvider.store(fundMovements: fundTransactionList, forFundId: fundNumber)
        }
    }

    func processFilteredMovementsResult(_ fundNumber: String, filter: FundTransactionsParameters, result: Result<FundTransactionListDTO, NetworkProviderError>) {
        if case .success(let fundTransactionList) = result {
            self.bsanDataProvider.store(fundMovements: fundTransactionList, forFundId: fundNumber, andFilter: filter)
        }
    }
}
