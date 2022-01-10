//
//  DateSelectorConfiguration.swift
//  TaxTransfer
//
//  Created by 185167 on 04/01/2022.
//

struct TaxFormConfiguration {
    let amountField: AmountFieldConfiguration
    let dateSelector: DateSelectorConfiguration
    
    struct AmountFieldConfiguration {
        let amountFormatter: NumberFormatter
    }
    
    struct DateSelectorConfiguration {
        let language: String
        let dateFormatter: DateFormatter
    }
}
