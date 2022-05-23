//
//  PLGetSavingDetailsInfoUseCase.swift
//  Santander
//
//  Created by Marcos Álvarez Mesa on 28/4/22.
//

import Foundation
import OpenCombine
import CoreDomain
import SavingProducts
import CoreFoundationLib
import SANPLLibrary

final class PLGetSavingDetailsInfoUseCase: GetSavingDetailsInfoUseCase {
    let dependenciesResolver: DependenciesResolver
    lazy var provider = {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getSavingManager()
    }()

    lazy var locale: Locale = {
        let stringLoader: StringLoader = dependenciesResolver.resolve(for: StringLoader.self)
        let identifier = stringLoader.getCurrentLanguage().languageType.rawValue
        return Locale(identifier: identifier)
    }()

    public init(dependencies: DependenciesResolver) {
        self.dependenciesResolver = dependencies
    }

    func fechDetailElementsPublisher(saving: SavingProductRepresentable) -> AnyPublisher<[SavingDetailsInfoRepresentable], Error> {
        guard let accountId = saving.identification?.replacingOccurrences(of: " ", with: "") else {
            return Fail(error: NSError(description: "AccountNo not found")).eraseToAnyPublisher()
        }

        switch saving.accountSubType {
        case PLSavingTransactionsRepositoryProductType.term.rawValue:
            return fetchDetailsForTerms(with: accountId)
        case PLSavingTransactionsRepositoryProductType.savingProduct.rawValue:
            return fetchDetailsForSavings(with: accountId)
        default:
            return Fail(error: NSError(description: "Wrong subtype")).eraseToAnyPublisher()
        }
    }
}

private extension PLGetSavingDetailsInfoUseCase {

    func fetchDetailsForTerms(with accountId: String) -> AnyPublisher<[SavingDetailsInfoRepresentable], Error> {
        do {
            let result = try provider.loadTermAdditionDetails(accountId: accountId)
            switch result {
            case .success(let result):
                let elements = buildTermDetails(with: result)
                return Just(elements).tryMap { return $0 }.eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func fetchDetailsForSavings(with accountId: String) -> AnyPublisher<[SavingDetailsInfoRepresentable], Error> {
        do {
            let result = try provider.loadSavingAdditionDetails(accountId: accountId)
            switch result {
            case .success(let result):
                let elements = buildSavingDetails(with: result)
                return Just(elements).tryMap { return $0 }.eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

private extension PLGetSavingDetailsInfoUseCase {

    func buildTermDetails(with termDetailsDTO: TermDetailsDTO) -> [SavingDetailsInfoRepresentable] {
        var elements: [SavingDetailsInfoRepresentable] = []
        elements.append(SavingDetailsInfo(type: .number))
        elements.append(SavingDetailsInfo(type: .alias))
        elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_tenor"),
                                                        value: termDetailsDTO.tenorValue,
                                                        titleIdentifier: "savings_label_tenor",
                                                        valueIdentifier: "savingsLabelTenorValue")))
        elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_renewal"),
                                                        value: termDetailsDTO.renewalValue,
                                                        titleIdentifier: "savings_label_renewal",
                                                        valueIdentifier: "savingsLabelRenewalValue")))
        elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_interestCapitalization"),
                                                        value: termDetailsDTO.interestCapitalizationValue,
                                                        titleIdentifier: "savings_label_interestCapitalization",
                                                        valueIdentifier: "savingsLabelInterestCapitalizationValue")))
        if let openingDate = termDetailsDTO.openingDate {
            elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_openingDate"),
                                                            value: openingDate.prettyDate(with: locale),
                                                            titleIdentifier: "savings_label_openingDate",
                                                            valueIdentifier: "savingsLabelOpeningDateValue")))
        }
        if let lastCapitalizationDate = termDetailsDTO.lastCapitalizationDate {
            elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_lastCapitalizationDate"),
                                                            value: lastCapitalizationDate.prettyDate(with: locale),
                                                            titleIdentifier: "savings_label_lastCapitalizationDate",
                                                            valueIdentifier: "savingsLabelLastCapitalizationDateValue")))
        }
        if let nextCapitalizationDate = termDetailsDTO.nextCapitalizationDate {
            elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_nextCapitalizationDate"),
                                                            value: nextCapitalizationDate.prettyDate(with: locale),
                                                            titleIdentifier: "savings_label_nextCapitalizationDate",
                                                            valueIdentifier: "savingsLabelNextCapitalizationDateValue")))
        }
        return elements
    }

    func buildSavingDetails(with savingDetailsDTO: [SavingDetailsDTO]) -> [SavingDetailsInfoRepresentable] {
        var elements: [SavingDetailsInfoRepresentable] = []
        elements.append(SavingDetailsInfo(type: .number, action: .share))
        elements.append(SavingDetailsInfo(type: .alias))
        elements.append(SavingDetailsInfo(type: .custom(title: localized("savings_label_bonusInterestRate"),
                                                        value: savingDetailsDTO.hasBonus.localizedValue,
                                                        titleIdentifier: "savings_label_bonusInterestRate",
                                                        valueIdentifier: "savingsLabelBonusInterestRateValue")))
        return elements
    }
}

// MARK: Array extension
private extension Array where Element == SavingDetailsDTO {
    var hasBonus: Bool {
        guard self.count > 0 else { return false }
        let detail = self[0]
        guard detail.bonusCategory == SavingBonusCategory.interesRates.rawValue else { return false }
        return detail.bonusStatus == SavingBonusStatus.active.rawValue
    }
}

// MARK: TermDetailsDTO extension
private extension TermDetailsDTO {
    var interestCapitalizationValue: String {
        return (self.interestCapitalization ?? false == true).localizedValue
    }

    var renewalValue: String {
        return (self.renewal ?? false == true).localizedValue
    }

    var tenorValue: String {
        return "\(self.tenor?.period ?? 0) \(self.tenor?.unit ?? "")"
    }
}

// MARK: Bool extension
private extension Bool {
    var localizedValue: String {
        return self == true ? localized("generic_link_yes") : localized("generic_link_no")
    }
}

// MARK: String extension
private extension String {
    func prettyDate(with locale: Locale) -> String {
        let dateFormatterReader = DateFormatter()
        dateFormatterReader.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatterReader.date(from: self) else { return "" }

        let dateFormatterWriter = DateFormatter()
        dateFormatterWriter.locale = locale
        dateFormatterWriter.dateFormat = "dd/MM/yyyy"
        dateFormatterWriter.timeZone = .none
        return dateFormatterWriter.string(from: date)
    }
}
