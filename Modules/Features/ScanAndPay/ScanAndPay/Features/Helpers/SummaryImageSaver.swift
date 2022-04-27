//
//  SummaryImageSaver.swift
//  ScanAndPay
//
//  Created by 188216 on 15/04/2022.
//

import Foundation

protocol SummaryImageSaverProtocol {
    func saveSummaryImage(_ image: UIImage, completion: @escaping (Error?) -> Void)
}

final class SummaryImageSaver: NSObject, SummaryImageSaverProtocol {
    
    private var completion: ((Error?) -> Void)?
    
    func saveSummaryImage(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion?(error)
    }
}
