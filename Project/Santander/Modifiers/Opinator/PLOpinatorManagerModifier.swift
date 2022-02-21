//
//  PLOpinatorManagerModifier.swift
//  Santander
//
//  Created by Alvaro Royo on 9/2/22.
//

import Foundation
import RetailLegacy

final class PLOpinatorManagerModifier: OpinatorManagerModifier {
    func modifyOpinatorConfiguration(with configuration: OpinatorWebViewConfiguration) -> OpinatorWebViewConfiguration {
        var config = configuration
        config.showBackButton = false
        return config
    }
}
