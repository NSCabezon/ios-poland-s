//
//  ConfirmationTimerView.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 26/10/21.
//

import UI
import Commons
import PLCommons

public protocol RemainingTimeDelegate: AnyObject {
    func didTimerEnd()
}

public final class RemainingTimeView: UIView {
    private struct Constants {
        static let secondsInAMinute: Int = 60
        static let smoothDivision: Double = 100
    }
    
    @IBOutlet private weak var clockImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var remainingTimeLabel: UILabel!
    @IBOutlet private weak var remainingSecondsLabel: UILabel!
    private var view: UIView?
    private var timer: Timer!
    private var timerCounter: Float = 0
    private var totalTime: Float = 0
    weak var delegate: RemainingTimeDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    func setViewModel(_ viewModel: RemainingTimeViewModel) {
        self.configureTimer(with: viewModel)
        self.startTimer()
    }
}

private extension RemainingTimeView {
    func configureView() {
        self.xibSetup()
        self.configureImage()
        self.configureLabels()
        self.prepareProgressView()
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
    
    func configureImage() {
        self.clockImage.image = Assets.image(named: "oneIcnEditTime")
    }
    
    func configureLabels() {
        self.titleLabel.font = .typography(fontName: .oneH100Bold)
        self.titleLabel.textColor = .oneLisboaGray
        self.titleLabel.configureText(withKey: "authorization_label_confirmTheOperation")
        self.remainingTimeLabel.font = .typography(fontName: .oneB200Regular)
        self.remainingTimeLabel.textColor = .oneBrownGray
        self.remainingTimeLabel.configureText(withKey: "authorization_label_thatStillLeaves")
        self.remainingSecondsLabel.font = .typography(fontName: .oneB300Bold)
        self.remainingSecondsLabel.textColor = .oneLisboaGray
    }
    
    func prepareProgressView() {
        self.progressView.progressTintColor = .oneDarkTurquoise
        self.progressView.trackTintColor = .oneMediumSkyGray
        self.progressView.setProgress(1.00, animated: false)
    }
    
    func configureTimer(with viewModel: RemainingTimeViewModel) {
        self.timerCounter = viewModel.totalTime
        self.totalTime = viewModel.totalTime
        self.updateSeconds(viewModel.totalTime)
    }
    
    func updateSeconds(_ seconds: Float) {
        self.progressView.setProgress(seconds/self.totalTime, animated: true)
        let localizedText = localized("sendMoney_label_progressBarTimer", [StringPlaceholder(.value, formatTime(Int(seconds)))])
        self.remainingSecondsLabel.configureText(withLocalizedString: localizedText)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = formatUnits(String(seconds / Constants.secondsInAMinute))
        let shortSeconds = formatUnits(String(seconds % Constants.secondsInAMinute))
        return "\(minutes):\(shortSeconds)"
    }
    
    func formatUnits(_ units: String) -> String {
        return units.count < 2 ? "0\(units)" : units
    }
    
    func setAccessibilityIdentifiers() {
        self.clockImage.accessibilityIdentifier = AccessibilityAuthorization.oneIcnEditTime
        self.titleLabel.accessibilityIdentifier = AccessibilityAuthorization.timerTitleLabel
        self.progressView.accessibilityIdentifier = AccessibilityAuthorization.timerProgressView
        self.remainingTimeLabel.accessibilityIdentifier = AccessibilityAuthorization.remainingTimeLabel
        self.remainingSecondsLabel.accessibilityIdentifier = AccessibilityAuthorization.remainingSecondsLabel
    }
}

private extension RemainingTimeView {
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: (1.0 / Constants.smoothDivision), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerCounter -= Float(1.0 / Constants.smoothDivision)
            self.updateSeconds(self.timerCounter)
            if self.timerCounter <= 0 {
                self.didTimerEnd()
            }
        }
    }
    
    func didTimerEnd() {
        self.delegate?.didTimerEnd()
        self.timer?.invalidate()
        self.timer = nil
    }
}
