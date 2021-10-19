//
//  HelpCenterPlainCell.swift
//  HelpCenterPlainCell
//
//  Created by 186484 on 04/08/2021.
//

import Commons
import PLUI
import UI

private enum Constants {
    static let titleTextFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)
    
    static let placeholderIcon = UIImage(named: "iconPlaceholder", in: .module, compatibleWith: nil)
    static let loaderFadeTime = TimeInterval(0.2)
    
    static let accesoryBorderLayerZPosition = -1
}

final class HelpCenterPlainCell: UITableViewCell {
    public static var identifier = "PLHelpCenterListCell"
        
    private let containterView = UIView()
    private let titleLabel = UILabel()
    private let cellImageView = UIImageView()
    private let accesoryImageView = UIImageView()
    private let accesoryBorderLayer = CAShapeLayer()
    
    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
    
    // MARK: - Private methods
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setCellIcon(_ icon: HelpCenterConfig.Element.Icon) {
        switch icon {
        case .local(let image):
            cellImageView.image = image
        case .remote(let imageUrl):
            cellImageView.kf.setImage(with: URL(string: imageUrl),
                                      options: [.transition(.fade(Constants.loaderFadeTime)),
                                                .onFailureImage(Constants.placeholderIcon)])
        case .none:
            break
        }
    }
    
    private func setAccesoryImageViewHidden(_ isHidden: Bool) {
        accesoryImageView.isHidden = isHidden
        accesoryBorderLayer.isHidden = isHidden
        if isHidden {
            containterView.drawBorder(cornerRadius: 4, color: .mediumSky, width: 1)
        }
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        addSubview(containterView)
        
        containterView.addSubview(titleLabel)
        containterView.addSubview(cellImageView)
        containterView.addSubview(accesoryImageView)
        
        addBorder()
        updatePath()

        backgroundColor = .white
        containterView.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        setUpTitleLabel()
        setCellUpImageView()
        setUpAccesoryImageView()
    }
        
    private func setUpLayouts() {
        containterView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        accesoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containterView.topAnchor.constraint(equalTo: topAnchor),
            containterView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0),
            containterView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20.0),
            containterView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            
            cellImageView.leftAnchor.constraint(equalTo: containterView.leftAnchor, constant: 12.0),
            cellImageView.centerYAnchor.constraint(equalTo: containterView.centerYAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 24.0),
            cellImageView.widthAnchor.constraint(equalToConstant: 24.0),
            
            titleLabel.topAnchor.constraint(equalTo: containterView.topAnchor, constant: 14.0),
            titleLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 13.0),
            titleLabel.rightAnchor.constraint(equalTo: containterView.rightAnchor, constant: -11.0),
            titleLabel.bottomAnchor.constraint(equalTo: containterView.bottomAnchor, constant: -14.0),
            
            accesoryImageView.topAnchor.constraint(equalTo: containterView.topAnchor),
            accesoryImageView.rightAnchor.constraint(equalTo: containterView.rightAnchor),
            accesoryImageView.heightAnchor.constraint(equalToConstant: 24.0),
            accesoryImageView.widthAnchor.constraint(equalToConstant: 23.0)
        ])
    }
    
    private func setUpTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.applyStyle(LabelStylist(textColor: .lisboaGray, font: Constants.titleTextFont, textAlignment: .left))
    }
    
    private func setCellUpImageView() {
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.backgroundColor = .clear
        cellImageView.kf.indicatorType = .activity
        (cellImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .santanderRed
    }
    
    private func setUpAccesoryImageView() {
        accesoryImageView.image = UIImage(named: "phoneCornerIcon", in: .module, compatibleWith: nil)
        accesoryImageView.contentMode = .scaleAspectFit
        accesoryImageView.backgroundColor = .clear
    }
    
    private func addBorder() {
        accesoryBorderLayer.strokeColor = UIColor.mediumSky.cgColor
        accesoryBorderLayer.fillColor = UIColor.clear.cgColor
        accesoryBorderLayer.lineWidth = 1
        containterView.layer.addSublayer(accesoryBorderLayer)
    }
    
    private func updatePath() {
        // starting
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: containterView.bounds.minX + 4, y: containterView.bounds.minY + 4),
                    radius: 4,
                    startAngle: CGFloat(3 * Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: false) // 1st top left rounded corner
        path.addLine(to: CGPoint(x: containterView.bounds.minX, y: containterView.bounds.maxY - 4))
        
        path.addArc(withCenter: CGPoint(x: containterView.bounds.minX + 4, y: containterView.bounds.maxY - 4),
                    radius: 4,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: false) // 2st bottom left rounded corner
        path.addLine(to: CGPoint(x: containterView.bounds.maxX - 4, y: containterView.bounds.maxY))
        
        path.addArc(withCenter: CGPoint(x: containterView.bounds.maxX - 4, y: containterView.bounds.maxY - 4),
                    radius: 4,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false) // 3st bottom right rounded corner
        path.addLine(to: CGPoint(x: containterView.bounds.maxX, y: containterView.bounds.midY))
        
        path.addLine(to: CGPoint(x: containterView.bounds.maxX - containterView.bounds.midY, y: containterView.bounds.minY))
        path.close()
        
        accesoryBorderLayer.path = path.cgPath
    }
}

extension HelpCenterPlainCell: ElementViewModelSetUpable {
    func setUp(with viewModel: HelpCenterElementViewModel) {
        setTitle(viewModel.element.title)
        setCellIcon(viewModel.element.icon)
        setAccesoryImageViewHidden(viewModel.element.isAccesoryImageViewHidden)
    }
}
