//
//  SummaryViewModel.swift
//  ScanAndPay
//
//  Created by 188216 on 12/04/2022.
//

import Foundation
import SANPLLibrary

struct SummaryViewModel {
    let isInCompanyContext: Bool
    let qrCodeImage: UIImage?
    let fields: [SummaryFieldViewModel]
}
