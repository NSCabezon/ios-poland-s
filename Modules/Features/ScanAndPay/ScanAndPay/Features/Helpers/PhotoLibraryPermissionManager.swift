//
//  PhotoLibraryPermissionManager.swift
//  ScanAndPay
//
//  Created by 188216 on 15/04/2022.
//

import Foundation
import Photos

protocol PhotoLibraryPermissionsManagerProtocol {
    func requestPhotoLibraryPermissions(_ completion: @escaping (PhotoLibraryAuthorizationStatus) -> Void)
}

enum PhotoLibraryAuthorizationStatus {
    case authorized
    case denied
}

final class PhotoLibraryPermissionsManager: PhotoLibraryPermissionsManagerProtocol {
    func requestPhotoLibraryPermissions(_ completion: @escaping (PhotoLibraryAuthorizationStatus) -> Void) {
        DispatchQueue.main.async { [weak self] in
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                self?.handleNotDeterminedStatus(completion)
            case .restricted:
                completion(.denied)
            case .denied:
                completion(.denied)
            case .authorized:
                completion(.authorized)
            case .limited:
                completion(.denied)
            @unknown default:
                completion(.denied)
            }
        }
    }
    
    private func handleNotDeterminedStatus(_ completion: @escaping (PhotoLibraryAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { requestStatus in
            DispatchQueue.main.async {
                let status: PhotoLibraryAuthorizationStatus = requestStatus == .authorized ? .authorized : .denied
                completion(status)
            }
        }
    }
}
