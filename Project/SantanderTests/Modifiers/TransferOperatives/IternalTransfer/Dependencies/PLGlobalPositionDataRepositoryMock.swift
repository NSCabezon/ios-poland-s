//
//  PLGlobalPositionDataRepositoryMock.swift
//  SantanderTests
//
//  Created by Cristobal Ramos Laina on 17/3/22.
//

import Foundation
import TransferOperatives
import SANPLLibrary
import CoreDomain
import OpenCombine
@testable import IDZSwiftCommonCrypto

struct PLGlobalPositionDataRepositoryMock: GlobalPositionDataRepository {
    func send(_ globalPosition: GlobalPositionDataRepresentable) {
        fatalError()
    }
    
    func getGlobalPosition() -> AnyPublisher<GlobalPositionDataRepresentable, Never> {
        fatalError()
    }
    
    func send(_ mergedGlobalPosition: GlobalPositionAndUserPrefMergedRepresentable) {
        fatalError()
    }
    
    func getMergedGlobalPosition() -> AnyPublisher<GlobalPositionAndUserPrefMergedRepresentable, Never> {
        fatalError()
    }
}
