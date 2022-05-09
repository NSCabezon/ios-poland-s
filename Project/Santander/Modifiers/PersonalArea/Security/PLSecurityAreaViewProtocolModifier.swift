//
//  PLSecurityAreaViewProtocolModifier.swift
//  Santander
//
//  Created by Jose Servet Font on 29/4/22.
//

import Foundation
import PersonalArea

class PLSecurityAreaViewProtocolModifier: SecurityAreaViewProtocolModifier {
    let showIconTitleHeader = true
    let tooltipItems = [(text: "securityTooltip_text_alert", image: "icnRing"),
                        (text: "securityTooltip_text_fraud", image: "icnFraud"),
                        (text: "securityTooltip_text_cardTheft", image: "icnStolenCard")]
}
