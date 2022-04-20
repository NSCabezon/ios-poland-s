//
//  BarcodeScannerView.swift
//  PLUI
//
//  Created by 188216 on 17/03/2022.
//

import UIKit
import AVFoundation

public enum BarcodeScanneError: Error {
    case scannerInitializationFailed
    case barcodeTypesNotSupported
}

public protocol BarcodeScannerViewDelegate: AnyObject {
    func scannerView(_ view: BarcodeScannerView, didCaptureCode code: String)
}

public final class BarcodeScannerView: UIView {
    // MARK: Public Properties
    
    public weak var delegate: BarcodeScannerViewDelegate?
    
    /// Should be set before calling initializeScanner
    public var cameraPosition: AVCaptureDevice.Position = .back
    
    /// Should be set before calling initializeScanner
    public var barcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    // MARK: Private properties
    
    private let videoView = UIView()
    private lazy var captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    private var isInitialized = false
    
    // MARK: Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp
    
    private func setUp() {
        addSubviewConstraintToEdges(videoView)
        setUpNotifications()
    }
    
    private func setUpNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePreviewLayerSizeAndOrientation),
            name: UIApplication.didChangeStatusBarFrameNotification,
            object: nil
        )
    }
    
    // MARK: Methods
    
    /// Call before startScanning()
    public func initializerScanner() throws {
        if isInitialized {
            return
        }
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) else {
            throw BarcodeScanneError.scannerInitializationFailed
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            throw BarcodeScanneError.scannerInitializationFailed
        }
        
        guard captureSession.canAddInput(videoInput) else {
            throw BarcodeScanneError.scannerInitializationFailed
        }
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        guard captureSession.canAddOutput(metadataOutput) else {
            throw BarcodeScanneError.scannerInitializationFailed
        }
        captureSession.addOutput(metadataOutput)
        
        let availableBarcodeTypes = Array(Set(metadataOutput.availableMetadataObjectTypes).intersection(barcodeTypes))
        guard !availableBarcodeTypes.isEmpty else {
            throw BarcodeScanneError.barcodeTypesNotSupported
        }
        metadataOutput.metadataObjectTypes = availableBarcodeTypes
        
        previewLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(previewLayer)
        updatePreviewLayerSizeAndOrientation()
        
        isInitialized = true
    }
    
    /// Starts scanning, usually you should call this on viewDidAppear
    public func startScanning() {
        updatePreviewLayerSizeAndOrientation()
        captureSession.startRunning()
    }
    
    /// Stops scanning, usually you should call this on viewWillDisappear or when barcode is detected
    public func stopScanning() {
        captureSession.stopRunning()
    }
    
    @objc
    private func updatePreviewLayerSizeAndOrientation() {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        if previewLayer.connection?.isVideoOrientationSupported ?? false {
            switch interfaceOrientation {
            case .portrait:
                previewLayer.connection?.videoOrientation = .portrait
            case .portraitUpsideDown:
                previewLayer.connection?.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                previewLayer.connection?.videoOrientation = .landscapeLeft
            case .landscapeRight:
                previewLayer.connection?.videoOrientation = .landscapeRight
            default:
                break
            }
        }
        
        self.previewLayer.frame = self.videoView.bounds
    }
}

extension BarcodeScannerView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableCodeObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let code = readableCodeObject.stringValue else {
            return
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        delegate?.scannerView(self, didCaptureCode: code)
    }
}
