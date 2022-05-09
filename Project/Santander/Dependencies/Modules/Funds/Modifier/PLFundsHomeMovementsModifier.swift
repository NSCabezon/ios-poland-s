//
//  PLFundsHomeMovementsModifier.swift
//  Santander
//

import Funds
import CoreDomain

final class PLFundsHomeMovementsModifier: FundsHomeMovementsModifier {
    var isMoreDetailInfoEnabled: Bool = false

    func getUnits(for movement: FundMovementRepresentable) -> String? {
        movement.unitsRepresentable?.replace(".", ",")
    }
}
