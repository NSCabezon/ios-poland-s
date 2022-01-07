//
//  TappableControl.swift
//  PLUI
//
//  Created by 185167 on 13/12/2021.
//

import UI

open class TappableControl: UIControl {
    public var onTap: (() -> Void)?
    private let highlightLayer = UIView()
    private let configuration: Configuration
    
    public init(configuration: Configuration = .defaultConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: configuration.highlightAnimationTime) {
                self.highlightLayer.alpha =
                    self.isHighlighted ?
                    self.configuration.visibleHighlightAlpha :
                    self.configuration.invisibleHighlightAlpha
            }
        }
    }
}

private extension TappableControl {
    func setUp() {
        configureSubviews()
        configureStyling()
        configureTargets()
    }
    
    func configureSubviews() {
        addSubview(highlightLayer)
        highlightLayer.translatesAutoresizingMaskIntoConstraints = false
        highlightLayer.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            highlightLayer.topAnchor.constraint(equalTo: topAnchor),
            highlightLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlightLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            highlightLayer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureStyling() {
        layer.cornerRadius = configuration.cornerRadius
        highlightLayer.alpha = configuration.invisibleHighlightAlpha
        highlightLayer.backgroundColor = configuration.highlightColor
        highlightLayer.layer.cornerRadius = configuration.cornerRadius
    }
    
    func configureTargets() {
        addTarget(
            self,
            action: #selector(didTapControl),
            for: .touchUpInside
        )
    }
    
    @objc func didTapControl() {
        onTap?()
    }
}

public extension TappableControl {
    struct Configuration {
        let highlightAnimationTime: TimeInterval
        let visibleHighlightAlpha: CGFloat
        let invisibleHighlightAlpha: CGFloat = 0.0
        let highlightColor: UIColor
        let cornerRadius: CGFloat
        
        public init(
            highlightAnimationTime: TimeInterval,
            visibleHighlightAlpha: CGFloat,
            highlightColor: UIColor,
            cornerRadius: CGFloat
        ) {
            self.highlightAnimationTime = highlightAnimationTime
            self.visibleHighlightAlpha = visibleHighlightAlpha
            self.highlightColor = highlightColor
            self.cornerRadius = cornerRadius
        }
        
        public static var defaultConfiguration: Configuration {
            return Configuration(
                highlightAnimationTime: 0.3,
                visibleHighlightAlpha: 0.5,
                highlightColor: UIColor(white: 192/255, alpha: 1.0),
                cornerRadius: 5
            )
        }
    }
}

