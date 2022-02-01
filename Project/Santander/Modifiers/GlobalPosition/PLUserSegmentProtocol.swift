//
//  PLUserSegmentProtocol.swift
//  Santander
//
//  Created by Ernesto Fernandez Calles on 28/1/22.
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary

final class PLUserSegmentProtocol: UserSegmentProtocol {

    lazy private var customerManager: PLCustomerManagerProtocol = {
        return self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
    }()

    private let dependenciesResolver: DependenciesResolver

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func getUserSegment(_ completion: @escaping (SegmentTypeEntity, String?) -> Void) {
        let customer = try? customerManager.getIndividual().get()

        if let marketingSegment = customer?.marketingSegment {
            switch Int(marketingSegment) {
            case 30, 31, 32, 33, 34, 35, 92, 94, 99:
                completion(.retail, nil)
            case 50, 51, 52, 54, 55, 56, 57, 58, 59, 95:
                completion(.select, nil)
            case 53, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 96:
                completion(.privateBanking, nil)
            default:
                completion(.retail, nil)
            }
        } else {
            completion(.retail, nil)
        }
    }
}
