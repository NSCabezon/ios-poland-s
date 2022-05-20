import UI
import CoreFoundationLib
import UIKit

protocol PLQuickBalanceSelectableDelegate: NSObject {
    func didSelectOneSmallSelectorListView(_ index: Int)
}

public final class PLQuickBalanceSelectableView: XibView {
    private enum Constants {
        static let borderWidth: CGFloat = 1.0
        static let cornerIconName: String = "icnCheckOvalGreen"
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    
    @IBOutlet private weak var cornerIconImageView: UIImageView!
    private var status: PLQuickBalanceSelectableViewModel.Status = .inactive
    private var index: Int = 0
    weak var delegate: PLQuickBalanceSelectableDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    
    public func setViewModel(_ viewModel: PLQuickBalanceSelectableViewModel, index: Int = 0) {
        self.status = viewModel.status
        self.index = index
        self.configureByStatus()
        self.configureSubtitleLabel(viewModel.rightTextKey)
        self.setTopLabelText(viewModel.leftTextKey)
    }
    
    public func setStatus(_ status: PLQuickBalanceSelectableViewModel.Status) {
        self.status = status
        self.configureByStatus()
    }
}

private extension PLQuickBalanceSelectableView {
    func configureView() {
        self.configureViews()
        self.configureImageViews()
    }
    
    func configureViews() {
        self.contentView.layer.borderWidth = Constants.borderWidth
        self.contentView.layer.borderColor = UIColor.oneMediumSkyGray.cgColor
        self.contentView.setOneCornerRadius(type: .oneShRadius8)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnContentView))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func configureImageViews() {
        self.cornerIconImageView.image = Assets.image(named: Constants.cornerIconName)
    }
        
    func configureSubtitleLabel(_ text: String) {
        self.subtitleLabel.text = localized(text)
        self.subtitleLabel.textColor = self.status.titleTextColor
        self.subtitleLabel.font = self.status.subtitleTextFont
    }
    
    func setTopLabelText(_ textKey: String) {
        self.titleLabel.text = localized(textKey)
    }
    
    func toggleStatus() {
        switch self.status {
        case .activated:
            self.status = .inactive
        case .inactive:
            self.status = .activated
        }
        self.configureByStatus()
    }
    
    func configureByStatus() {
        self.contentView.backgroundColor = self.status.backgroundColor
        self.contentView.layer.borderWidth = self.status.borderWidth
        self.titleLabel.textColor = self.status.titleTextColor
        self.titleLabel.font = self.status.titleTextFont
        self.subtitleLabel.textColor = self.status.titleTextColor
        self.subtitleLabel.font = self.status.subtitleTextFont
        self.cornerIconImageView.isHidden = self.status != .activated
    }
    
    @objc func didTapOnContentView() {
        self.toggleStatus()
        self.delegate?.didSelectOneSmallSelectorListView(self.index)
        UIAccessibility.post(notification: .layoutChanged, argument: self.contentView)
    }
}
