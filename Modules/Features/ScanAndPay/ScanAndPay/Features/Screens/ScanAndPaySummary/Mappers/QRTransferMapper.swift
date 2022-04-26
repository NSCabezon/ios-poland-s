//
//  QRTransferMapper.swift
//  ScanAndPay
//
//  Created by 188216 on 12/04/2022.
//

import CoreFoundationLib
import Foundation

protocol QRTransferMapping {
    func map(model: QRTransferModel, isInCompanyContext: Bool) -> SummaryViewModel
}

final class QRTransferMapper: QRTransferMapping{
    
    private let qrGenerator: QRCodeGeneratorProtocol
    
    init(qrGenerator: QRCodeGeneratorProtocol) {
        self.qrGenerator = qrGenerator
    }
    
    func map(model: QRTransferModel, isInCompanyContext: Bool) -> SummaryViewModel {
        let image = qrGenerator.generateQrCode(from: model.rawCode)
        var fieldModels = [SummaryFieldViewModel]()
        if let taxIdentifier = model.taxIdentifier, isInCompanyContext {
            fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_nip"), value: taxIdentifier))
        }
        fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_accNum"), value: model.accountNumber))
        fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_recipient"), value: model.recipientName, isValueBold: true))
        if let amount = model.ammount {
            fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_amount"), value: "\(amount)"))
        }
        
        if let title = model.transferTitle {
            fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_title"), value: title))
        }
        
        if model.transferTitle.isNil, let secondaryTitlePart1 = model.reserveField1, let secondaryTitlePart2 = model.reserveField2 {
            fieldModels.append(SummaryFieldViewModel(title: localized("pl_scanAndPay_label_title"), value: secondaryTitlePart1 + secondaryTitlePart2))
        }
        
        if let lastField = fieldModels.last {
            fieldModels[fieldModels.count - 1] = SummaryFieldViewModel(title: lastField.title, value: lastField.value, showSeparator: false)
        }
        
        return SummaryViewModel(isInCompanyContext: isInCompanyContext, qrCodeImage: image, fields: fieldModels)
    }
}
