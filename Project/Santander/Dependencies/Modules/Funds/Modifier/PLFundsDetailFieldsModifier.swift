//
//  PLFundsDetailFieldsModifier.swift
//  Santander
//
//  Created by Simón Aparicio on 6/4/22.
//

import Funds
import CoreDomain
import CoreFoundationLib

class PLFundsDetailFieldsModifier: FundsDetailFieldsModifier {

    func getDetailFields(for fund: FundRepresentable, detail: FundDetailRepresentable?) -> [FundDetailSectionModel]? {
        let builder = FundDetailBuilder()
            .addSection()
            .addAlias(fund.alias)
            .addValuationDate(detail?.dateOfValuation())
            .addNumberOfUnits(detail?.numberOfUnits())
            .addValueOfAUnit(detail?.valueOfAUnit())
            .addTotalValue(detail?.totalValue())
            .addCategoryOfTheUnit(detail?.categoryRepresentable)

        return builder.build()
    }
}
