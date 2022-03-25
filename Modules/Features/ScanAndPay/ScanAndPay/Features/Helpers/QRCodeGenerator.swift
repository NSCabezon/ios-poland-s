//
//  QRCodeGenerator.swift
//  Pods
//
//  Created by 188216 on 18/03/2022.
//

import Foundation

protocol QRCodeGeneratorProtocol {
    func generateQrCode(from string: String) -> UIImage?
}

final class QRCodeGenerator: QRCodeGeneratorProtocol {
    
    // MARK: Properties
    
    private let qrCodeFilterName = "CIQRCodeGenerator"
    private let qrCodeScaleFactor: CGFloat = 3
    
    // MARK: Methods
    
    func generateQrCode(from string: String) -> UIImage? {
        let stringData = string.data(using: .utf8)
        guard let qrCodeFilter = CIFilter(name: qrCodeFilterName) else {
            return nil
        }
        
        qrCodeFilter.setValue(stringData, forKey: "inputMessage")
        let qrCodeScaleTransform = CGAffineTransform(scaleX: qrCodeScaleFactor, y: qrCodeScaleFactor)
        
        guard let filterOutput = qrCodeFilter.outputImage?.transformed(by: qrCodeScaleTransform) else {
            return nil
        }
        
        return UIImage(ciImage: filterOutput)
    }
}
