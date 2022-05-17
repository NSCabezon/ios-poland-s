//
//  PLGetSavingProductOptionsUseCase.swift
//  Santander
//
//  Created by Juan Sánchez Marín on 8/4/22.
//

import SavingProducts
import CoreDomain
import OpenCombine
import SANPLLibrary

struct PLGetSavingProductOptionsUseCase: GetSavingProductOptionsUseCase {
    private var repository: GlobalPositionDataRepository
    private let savingProductMatrix: PLGetSavingProductMatrixUseCase
    private static let homeItemsLimit = 4

    func fetchHomeOptions(contractNumber: String?, savingsProductType: String) -> AnyPublisher<[SavingProductOptionRepresentable], Never> {
        return getHomeOrderedOptions(contractNumber: contractNumber, savingsProductType: savingsProductType, itemsLimit: PLGetSavingProductOptionsUseCase.homeItemsLimit)
    }

    func fetchOtherOperativesOptions(contractNumber: String?, savingsProductType: String) -> AnyPublisher<[SavingProductOptionRepresentable], Never> {
        return getOtherOperativesOrderedOptions(contractNumber: contractNumber, savingsProductType: savingsProductType, itemsLimit: PLGetSavingProductOptionsUseCase.homeItemsLimit)
    }

    init(dependencies: ModuleDependencies) {
        repository = dependencies.resolve()
        savingProductMatrix = dependencies.resolve()
    }
}

private extension PLGetSavingProductOptionsUseCase {

    func getHomeOrderedOptions(contractNumber: String?, savingsProductType: String, itemsLimit: Int) -> AnyPublisher<[SavingProductOptionRepresentable], Never> {
        guard let contractNumber = contractNumber else {
            return Just([]).eraseToAnyPublisher()
        }
        return savingProductMatrix.fetchShortcutsConfiguration(for: contractNumber)
            .map({ shortcuts in
                let options = getSavingOptionsBaseList(productMatrixShortcuts: shortcuts, savingsProductTypeString: savingsProductType)
                let max = options.count > itemsLimit ? itemsLimit : options.count
                guard max > 0 else {
                    return []
                }
                return Array(options[0...(max-1)])
            })
            .eraseToAnyPublisher()
    }

    func getOtherOperativesOrderedOptions(contractNumber: String?, savingsProductType: String, itemsLimit: Int) -> AnyPublisher<[SavingProductOptionRepresentable], Never> {
        guard let contractNumber = contractNumber else {
            return Just([]).eraseToAnyPublisher()
        }

        return savingProductMatrix.fetchShortcutsConfiguration(for: contractNumber)
            .map({ pMatrixShortcuts in
                let options = getSavingOptionsBaseList(productMatrixShortcuts: pMatrixShortcuts, savingsProductTypeString: savingsProductType)
                return Array(options.dropFirst(itemsLimit))
            })
            .eraseToAnyPublisher()
    }

    func getSavingOptionsBaseList(productMatrixShortcuts: [OperationsProductsStatesDTO], savingsProductTypeString: String) -> [SavingProductOptionRepresentable] {

        var optionsArray = [(options: SavingProductOption, order: Int)]()
        for savingProductType in PLSavingProductOption.allCases {
            guard let accountSubtype = PLSavingTransactionsRepositoryProductType(rawValue: savingsProductTypeString),
                savingProductType.isValidAccountSubType(typeToCheck: accountSubtype) else {
                continue
            }
            if let index = productMatrixShortcuts.firstIndex(where: { $0.id == savingProductType.rawValue }),
               productMatrixShortcuts[index].state == "disabled" {
                continue
            }
            let newOption = SavingProductOption(title: savingProductType.title,
                                                imageName: savingProductType.iconName,
                                                imageColor: savingProductType.iconColor,
                                                accessibilityIdentifier: savingProductType.accessibilityIdentifier,
                                                type: savingProductType.type,
                                                titleIdentifier: "",
                                                imageIdentifier: "",
                                                otherOperativesSection: savingProductType.section
                                             )
            optionsArray.append((options: newOption, order: savingProductType.order()))
        }
        return optionsArray.sorted(by: { $0.order < $1.order }).map { $0.options }
    }
}
