//
//  PLGetLoanPDFInfoUseCase.swift
//  Santander
//
//  Created by alvola on 2/3/22.
//

import Foundation
import CoreDomain
import CoreFoundationLib
import Loans
import OpenCombine
import SANPLLibrary

struct PLGetLoanPDFInfoUseCase: GetLoanPDFInfoUseCase {
    private var oldResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.oldResolver = dependenciesResolver
    }
    
    func fetchLoanPDFInfo(receiptId: String) -> AnyPublisher<Data?, Never> {
        guard let languagePublisher = self.oldResolver.resolve(forOptionalType: StringLoaderReactive.self)?.getCurrentLanguage()
        else { return Just(nil).eraseToAnyPublisher() }
        let historyManagerPublisher = self.oldResolver.resolve(for: PLManagersProviderReactiveProtocol.self).getHistoryManager()
        return Publishers.Zip(languagePublisher,
                              historyManagerPublisher)
            .flatMap { (language, historyManager) in
                return getData(language: language,
                               historyManager: historyManager,
                               receiptId: receiptId)
            }.eraseToAnyPublisher()
    }
    
    func getData(language: Language, historyManager: PLHistoryManagerProtocol, receiptId: String) -> AnyPublisher<Data?, Never> {
        let languageType = language.languageType
        let data = try? historyManager.getReceipt(receiptId: receiptId,
                                                  language: languageType.rawValue.uppercased()).get()
        return Just(data).eraseToAnyPublisher()
    }
}
