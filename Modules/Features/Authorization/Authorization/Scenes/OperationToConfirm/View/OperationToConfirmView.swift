//
//  OperationToConfirmView.swift
//  Authorization
//
//  Created by 186484 on 14/04/2022.
//

import CoreFoundationLib
import UI
import PLCommons
import PLUI

private enum Constants {
    static let pinBoxSize =     CGSize(width: 55.0, height: 56.0)
    static let pinCharacterSet: CharacterSet = .decimalDigits
    static let smsBoxSize = Screen.isScreenSizeBiggerThanIphone5() ? CGSize(width: 39.0, height: 56.0) : CGSize(width: 34, height: 49)
}

class OperationToConfirmView: UIView, ProgressBarPresentable {

    //MARK: - Views
    private let scrollView = UIScrollView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 18
        return stackView
    }()
        
    private lazy var pinContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var facade = PLUIInputCodeAuthPinFacade()
    private lazy var pinInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                          delegate: self,
                                                          facade: self.facade,
                                                          elementSize: Constants.pinBoxSize,
                                                          requestedPositions: .all,
                                                          charactersSet: Constants.pinCharacterSet)
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 18
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = PLAssets.image(named: "deviceTrustIVR")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = localized("authorization_label_confirmTheOperation")
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelStylist = LabelStylist(textColor: .lisboaGray,
                                        font: .santander(family: .headline, type: .bold, size: 18.0),
                                        textAlignment: .center)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private let pinLabel: UILabel = {
        let label = UILabel()
        label.text = localized("authorization_label_enterYourPin")
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelStylist = LabelStylist(textColor: .lisboaGray,
                                        font: .santander(family: .headline, type: .regular, size: 18.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    let progressBar: ProgressBar = {
        let bar = ProgressBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setProgresColor(.darkTorquoise)
        bar.setProgressBackgroundColor(.clear)
        bar.setProgressAlpha(1)
        return bar
    }()
    
    private let expirationLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 16)
        label.textColor = .lisboaGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = LisboaButton()
        button.configureAsWhiteButton()
        let configuration = ShadowConfiguration(color: UIColor.lightSanGray,
                                                opacity: 0.7,
                                                radius: 3.0,
                                                withOffset: 0.0,
                                                heightOffset: 2.0)
        
        button.drawRoundedBorderAndShadow(with: configuration,
                                          cornerRadius: 6.0,
                                          borderColor: UIColor.mediumSkyGray,
                                          borderWith: 1.0)
        button.setTitle(localized("generic_link_cancel"), for: .normal)
        button.labelButtonLines(numberOfLines: 1)
        button.setTextAligment(.center, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction { [weak self] in
            self?.onCancelTapped?()
        }
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = RedLisboaButton()
        button.setTitle(localized("generic_button_confirm"), for: .normal)
        button.setTextAligment(.center, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction { [weak self] in
            self?.onConfirmTapped?()
        }
        return button
    }()
    
    private let operationDetailsView = OperationDetailsView()
    private let operationDetails3DSecureView = OperationDetails3DSecureView()
        
    var animator: UIViewPropertyAnimator?
    var onCancelTapped: (() -> Void)?
    var onConfirmTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.setRoundedCorners()
    }
    
    func setRemainingSeconds(_ seconds: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        let minutes = seconds / 60
        let seconds = seconds % 60
        let time = "\(minutes):\(numberFormatter.string(from: NSNumber(integerLiteral: seconds))!) \(localized("sek."))"
        
        let timeString = "\(localized("authorization_label_thatStillLeaves")) \(time)"
        let attrString = NSMutableAttributedString(string: timeString)
        
        let range = attrString.mutableString.range(of: time, options: .caseInsensitive)
        attrString.addAttribute(.font, value: UIFont.santander(family: .text, type: .bold, size: 16), range: range)
        expirationLabel.attributedText = attrString
    }
}

private extension OperationToConfirmView {
    func setup() {
        addSubviews()
        prepareLayout()
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(progressBar)
        stackView.addArrangedSubview(expirationLabel)
        
        stackView.addArrangedSubview(operationDetailsView)
        
        stackView.addArrangedSubview(pinContainerView)
        pinContainerView.addSubview(pinLabel)
        pinContainerView.addSubview(pinInputCodeView)
            
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    func prepareLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        operationDetailsView.translatesAutoresizingMaskIntoConstraints = false
        operationDetails3DSecureView.translatesAutoresizingMaskIntoConstraints = false
        pinInputCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50.0),
            imageView.widthAnchor.constraint(equalToConstant: 35.0),
            
            progressBar.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 25),
            progressBar.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -25),
            progressBar.heightAnchor.constraint(equalToConstant: 5),
            
            operationDetailsView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15),
            operationDetailsView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -15),
            
            pinContainerView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15),
            pinContainerView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -15),
            
            pinLabel.topAnchor.constraint(equalTo: pinContainerView.topAnchor, constant: 0),
            pinLabel.centerXAnchor.constraint(equalTo: pinContainerView.centerXAnchor),
            
            pinInputCodeView.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 8),
            pinInputCodeView.centerXAnchor.constraint(equalTo: pinContainerView.centerXAnchor),
            pinInputCodeView.heightAnchor.constraint(equalToConstant: Constants.pinBoxSize.height),
            pinInputCodeView.bottomAnchor.constraint(equalTo: pinContainerView.bottomAnchor),

            buttonsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonsStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            buttonsStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor)
        ])
    }
}

extension OperationToConfirmView: PLUIInputCodeViewDelegate {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        if view.isFulfilled() {
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = UIColor.santanderRed
        } else {
            self.confirmButton.isEnabled = view.isFulfilled()
            self.confirmButton.backgroundColor = UIColor.lightSanGray
        }
    }

    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {
        if string.count == 0 { return true }
        guard string.count > 0,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(character) == true else {
            return false
        }
        return true
    }
    
    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {
        
    }
    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) { }
}

