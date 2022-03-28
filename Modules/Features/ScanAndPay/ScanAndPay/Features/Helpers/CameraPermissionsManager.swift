//
//  CameraPermissionsManager.swift
//  Pods
//
//  Created by 188216 on 17/03/2022.
//

import Foundation
import AVFoundation

protocol CameraPermissionsManagerProtocol {
    func requestCameraPermissions(_ completion: @escaping (CameraPermissionsAuthorizationStatus) -> Void)
}

enum CameraPermissionsAuthorizationStatus {
    case authorized
    case deniedForTheFirstTime
    case denied
}

final class CameraPermissionsManager: CameraPermissionsManagerProtocol {
    func requestCameraPermissions(_ completion: @escaping (CameraPermissionsAuthorizationStatus) -> Void) {
        DispatchQueue.main.async { [weak self] in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                self?.handleNotDeterminedStatus(completion)
            case .restricted:
                completion(.denied)
            case .denied:
                completion(.denied)
            case .authorized:
                completion(.authorized)
            @unknown default:
                completion(.denied)
            }
        }
    }
    
    private func handleNotDeterminedStatus(_ completion: @escaping (CameraPermissionsAuthorizationStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { authorized in
            DispatchQueue.main.async {
                let status: CameraPermissionsAuthorizationStatus = authorized ? .authorized : .deniedForTheFirstTime
                completion(status)
            }
        }
    }
}
