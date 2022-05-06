//
//  TopUpAccountSelectorCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 26/04/2022.
//

import Foundation
import PLCommons

final class TopUpAccountSelectorCoordinator: AccountForDebitSelectorCoordinator {
    override func closeProcess() {
        navigationController?.closeTopUpProces()
    }
    
    override func back() {
        switch mode {
        case .mustSelectDefaultAccount:
            navigationController?.closeTopUpProces()
        case .changeDefaultAccount:
            navigationController?.popViewController(animated: true)
        }
    }
}
