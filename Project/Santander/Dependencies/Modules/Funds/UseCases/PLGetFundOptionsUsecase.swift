//
//  PLGetFundOptionsUsecase.swift
//  Santander
//

import Funds
import CoreFoundationLib
import CoreDomain
import Foundation
import OpenCombine

struct PLGetFundOptionsUsecase {}

extension PLGetFundOptionsUsecase: GetFundOptionsUsecase {
    func fetchOptionsPublisher() -> AnyPublisher<[FundOptionRepresentable], Never> {
        return Just([]).eraseToAnyPublisher()
    }
}
