//
//  EmptyEmmaTrackEventList.swift
//  Santander
//
//  Created by Jose C. Yebes on 4/05/2021.
//

import Foundation
import CoreFoundationLib

struct EmptyEmmaTrackEventList: EmmaTrackEventListProtocol {
    let globalPositionEventID: String = ""
    let accountsEventID: String = ""
    let cardsEventID: String = ""
    let transfersEventID: String = ""
    let billAndTaxesEventID: String = ""
    let personalAreaEventID: String = ""
    let managerEventID: String = ""
    let customerServiceEventID: String = ""
}
