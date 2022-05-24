//
//  TaxTransferTitleBuilder.swift
//  TaxTransfer
//
//  Created by 187831 on 24/05/2022.
//

import Foundation
import CoreFoundationLib

final class TaxTransferTitleBuilder {
    private let taxPayer: TaxPayer
    private let taxPayerInfo: SelectedTaxPayerInfo
    private let taxAuthority: SelectedTaxAuthority
    private let mapper: TaxIdentifierMapping
    private let obligationIdentifier: String
    private let period: TaxTransferBillingPeriodType?
    private let selectedBillingYear: String?
    private let selectedPeriodNumber: Int?

    init(taxPayer: TaxPayer,
         taxPayerInfo: SelectedTaxPayerInfo,
         taxAuthority: SelectedTaxAuthority,
         obligationIdentifier: String,
         period: TaxTransferBillingPeriodType?,
         selectedBillingYear: String?,
         selectedPeriodNumber: Int?,
         dependenciesResolver: DependenciesResolver) {
        self.taxPayer = taxPayer
        self.taxPayerInfo = taxPayerInfo
        self.taxAuthority = taxAuthority
        self.obligationIdentifier = obligationIdentifier
        self.period = period
        self.selectedBillingYear = selectedBillingYear
        self.selectedPeriodNumber = selectedPeriodNumber
        self.mapper = dependenciesResolver.resolve(for: TaxIdentifierMapping.self)
    }
    
    func build() -> String {
        let docInfo = getDocumentInfo()
        let billingPeriodInfo = getBillingPeriodInfo()
        let taxAuthority = getTaxAuthority()
        let obligationIdentifier = getObligationIdentifier()
        
        return docInfo + billingPeriodInfo + taxAuthority + obligationIdentifier
    }
}

private extension TaxTransferTitleBuilder {
    func getDocumentInfo() -> String {
        let docType = mapper.map(taxPayerInfo.idType).documentType
        let docNumber = taxPayerInfo.taxIdentifier.replace("/", "_")
        
        return "/TI/" + docType + docNumber
    }
    
    func getBillingPeriodInfo() -> String {
        let formattedYear = selectedBillingYear?.suffix(2) ?? ""
        let billingPeriod: String
    
        switch period {
        case .year:
            billingPeriod = "\(formattedYear)\(period?.short ?? "")"
        default:
            if let period = period?.short, let selectedPeriodNumber = selectedPeriodNumber {
                billingPeriod = "\(formattedYear)\(period)\(selectedPeriodNumber)"
            } else {
                billingPeriod = ""
            }
        }
        return "/OKR/" + (billingPeriod.isEmpty ? "0" : billingPeriod)
    }
    
    func getTaxAuthority() -> String {
        return "/SFP/" + taxAuthority.selectedTaxSymbol.name
    }
    
    func getObligationIdentifier() -> String {
        guard obligationIdentifier.isNotEmpty else {
            return ""
        }
        return "/TXT/" + obligationIdentifier.replace("/", "_")
    }
}
