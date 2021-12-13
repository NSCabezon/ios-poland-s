
import Foundation

enum DateTransferOption {
    case today, anotherDay
}

protocol TransferDateSegmentViewDelegate: AnyObject {
    func didSelectOption(_ option: DateTransferOption)
}

class TransferDateSegmentView: UIView {
    
    private let stackView = UIStackView()
    weak var delegate: TransferDateSegmentViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransferDateSegmentView {
    
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(TransferDateSegmentOptionView(option: .today, isSelected: true, delegate: self))
        stackView.addArrangedSubview(TransferDateSegmentOptionView(option: .anotherDay, isSelected: false, delegate: self))
    }
    
    func prepareStyles() {
        backgroundColor = .skyGray
        layer.cornerRadius = 8
        stackView.axis = .horizontal
        stackView.spacing = Const.Spacing.stackView
        stackView.distribution = .fillEqually
    }
    
    func setUpLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Const.Padding.stackView.top),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.Padding.stackView.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Const.Padding.stackView.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Const.Padding.stackView.bottom)
        ])
    }
}

extension TransferDateSegmentView: TransferDateOptionDelegate {
    
    func didSelectOption(_ option: DateTransferOption) {
        let optionViews = stackView.arrangedSubviews
        optionViews.forEach({
            if let optionView = $0 as? TransferDateSegmentOptionView {
                optionView.isSelected = optionView.option == option
            }
        })
        delegate?.didSelectOption(option)
    }
    
}

private extension TransferDateSegmentView {
    
    struct Const {
        struct Padding {
            static let stackView: UIEdgeInsets = .init(top: 4, left: 4, bottom: -4, right: -4)
        }
        struct Spacing {
            static let stackView: CGFloat = 16
        }
    }
}
