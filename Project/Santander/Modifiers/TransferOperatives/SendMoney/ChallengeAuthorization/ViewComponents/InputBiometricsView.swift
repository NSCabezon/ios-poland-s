//
//  InputBiometricsView.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 26/10/21.
//

import UI
import Commons
import PLCommons
import Models

public protocol InputBiometricsDelegate: AnyObject {
    func didTapBiometry()
}

public final class InputBiometricsView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var biometricsImage: UIImageView!
    @IBAction private func biometryAction(_ sender: Any) {
        self.delegate?.didTapBiometry()
    }
    private var view: UIView?
    private var biometryType: BiometryTypeEntity = .none
    private var imageLiteral: String {
        switch self.biometryType {
        case .faceId: return "oneIcnFaceId"
        case .touchId: return "oneIcnTouchId"
        case .error(biometry: _, error: _), .none: return ""
        }
    }
    weak var delegate: InputBiometricsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
}

private extension InputBiometricsView {
    func configureView() {
        self.xibSetup()
        self.configureLabel()
        self.configureImage()
        self.setAccessibilityIdentifiers()
    }
    
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view ?? UIView())
        self.view?.fullFit()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
    
    func configureLabel() {
        self.titleLabel.font = .typography(fontName: .oneB300Bold)
        self.titleLabel.textColor = .oneDarkTurquoise
        self.titleLabel.configureText(withKey: "authorization_label_useBiometrics")
    }
    
    func configureImage() {
        self.biometricsImage.image = Assets.image(named: self.imageLiteral)
    }
    
    func setAccessibilityIdentifiers() {
        self.titleLabel.accessibilityIdentifier = AccessibilityAuthorization.biometricsTitleLabel
        self.biometricsImage.accessibilityIdentifier = AccessibilityAuthorization.oneIcnBiometrics
        
    }
}

extension InputBiometricsView {
    func setViewModel(_ viewModel: InputBiometricsViewModel) {
        self.biometryType = viewModel.biometryType
        self.configureImage()
    }
}
