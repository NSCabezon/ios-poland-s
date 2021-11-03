//
//  HelpCenterExpandableHintCell.swift
//  PLHelpCenter
//

import Foundation
import UI
import Commons

private enum Constants {
    static let titleTextFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)
    static let descriptionTextFont = UIFont.santander(family: .micro, type: .regular, size: 12.0)
    static let linkTextFont = UIFont.santander(family: .micro, type: .bold, size: 12.0)
    
    // Separator
    static let separatorHeight: CGFloat = 1
}

final class HelpCenterExpandableHintCell: UITableViewCell {
    public static var identifier = "HelpCenterExpandableHintCell"
    
    private let topViewContainer = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let accesoryImageView = UIImageView()
    private let descriptionTextView = UITextView()
    private let separatorView = UIView()
    private var stackViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setDescription(_ description: String) {
        let attrText = try? NSAttributedString(htmlString: description, font: Constants.descriptionTextFont)
        descriptionTextView.attributedText = attrText
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        selectionStyle = .none
        
        topViewContainer.addSubview(titleLabel)
        topViewContainer.addSubview(accesoryImageView)
        
        stackView.axis = .vertical
        stackView.addArrangedSubview(topViewContainer)
        stackView.addArrangedSubview(descriptionTextView)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
    }
    
    private func setUpSubviews() {
        setUpTitleLabel()
        setUpAccesoryImageView()
        setUpDescriptionTextView()
        separatorView.backgroundColor = .sky
    }
    
    private func setUpLayouts() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topViewContainer.translatesAutoresizingMaskIntoConstraints = false
        accesoryImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor)
        stackViewBottomConstraint.priority = .defaultHigh
                        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topViewContainer.topAnchor, constant: 15.0),
            titleLabel.leftAnchor.constraint(equalTo: topViewContainer.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: accesoryImageView.leftAnchor, constant: 15.0),
            titleLabel.bottomAnchor.constraint(equalTo: topViewContainer.bottomAnchor, constant: -15.0),
            
            accesoryImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            accesoryImageView.rightAnchor.constraint(equalTo: topViewContainer.rightAnchor),
            accesoryImageView.widthAnchor.constraint(equalToConstant: 24),
            accesoryImageView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackViewBottomConstraint,
            
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setUpTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.applyStyle(LabelStylist(textColor: .accessibleDarkSky,
                                           font: Constants.titleTextFont,
                                           textAlignment: .left))
    }
    
    private func setUpDescriptionTextView() {
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.linkTextAttributes = [NSAttributedString.Key.font: Constants.linkTextFont,
                                                  NSAttributedString.Key.foregroundColor: UIColor.darkTorquoise,
                                                  NSAttributedString.Key.underlineStyle: 0,
                                                  NSAttributedString.Key.underlineColor: UIColor.clear]
    }
    
    private func setUpAccesoryImageView() {
        accesoryImageView.image = UIImage(named: "icnArrowDown", in: .module, compatibleWith: nil)
        accesoryImageView.contentMode = .scaleAspectFit
        accesoryImageView.backgroundColor = .clear
    }
    
    private func updateAccesoryImage(isExpanded: Bool) {
        let rotation = isExpanded ? self.transform.rotated(by: CGFloat.pi) : CGAffineTransform.identity
        accesoryImageView.transform = rotation
    }
    
}

extension HelpCenterExpandableHintCell: ElementViewModelSetUpable {
    func setUp(with viewModel: HelpCenterElementViewModel) {
        setTitle(viewModel.element.title)
        setDescription(viewModel.element.description)
    }
}

extension HelpCenterExpandableHintCell: SectionViewModelExpandable {
    func setExpanded(_ isExpanded: Bool, animated: Bool) {
    
        let expandAction = { [weak self] in
            guard let self = self else { return }
            self.descriptionTextView.isHidden = !isExpanded
            self.updateAccesoryImage(isExpanded: isExpanded)
            self.stackViewBottomConstraint.constant = isExpanded ? -22.0 : 0.0
            self.stackView.layoutIfNeeded()
        }
        if animated {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    expandAction()
                },
                completion: nil
            )
        } else {
            expandAction()
        }
    }
}

extension HelpCenterExpandableHintCell: SectionViewModelSeparatorSetapable {
    func setSeparatorVisible(_ isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
}

private extension HelpCenterConfig.Element {

    var description: String {
        guard case let .expandableHint(_, answer) = self else { return "" }
        return answer
    }
    
}

private extension NSAttributedString {
    //NOTE: Based on https://stackoverflow.com/a/47612079
    convenience init(htmlString html: String, font: UIFont? = nil) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let fontSize: CGFloat? = font?.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                var font = Constants.descriptionTextFont
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    if let descriptor = descrip.withSymbolicTraits(.traitBold) {
                        descrip = descriptor
                        font = UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize)
                    }
                }
                attr.addAttribute(.font, value: font, range: range)
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            attr.addAttributes([ NSAttributedString.Key.paragraphStyle: paragraphStyle ], range: range)
            attr.addAttributes([ NSAttributedString.Key.foregroundColor: UIColor.lisboaGray ], range: range)
        }
        
        self.init(attributedString: attr)
    }
    
}
