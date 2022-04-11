//
//  SendMoneyTransferTypeRadioButtonsContainerView.swift
//  Santander
//
//  Created by Angel Abad Perez on 20/10/21.
//

import UI
import UIOneComponents
import CoreFoundationLib

protocol SendMoneyTransferTypeRadioButtonsContainerViewDelegate: AnyObject {
    func didSelectRadioButton(at index: Int)
    func didTapTooltip()
}

final class SendMoneyTransferTypeRadioButtonsContainerView: UIView {
    private enum Constants {
        static let defaultIndex: Int = .zero
        enum HorizontalStackView {
            static let spacing: CGFloat = 16.0
        }
        enum SeparatorView {
            static let height: CGFloat = 1.0
        }
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var delegate: SendMoneyTransferTypeRadioButtonsContainerViewDelegate?
    private var selectedIndex: Int = Constants.defaultIndex
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setViewModel(_ viewModel: SendMoneyTransferTypeRadioButtonsContainerViewModel) {
        guard !viewModel.viewModels.isEmpty else { return }
        self.stackView.removeAllArrangedSubviews()
        self.setViews(viewModel.viewModels)
        self.selectedIndex = viewModel.selectedIndex
        self.didSelectTransferType(at: self.selectedIndex)
    }
}

private extension SendMoneyTransferTypeRadioButtonsContainerView {
    func setupView() {
        self.xibSetup()
    }
    
    func xibSetup() {
        self.view = self.loadViewFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.view ?? UIView())
        self.view?.fullFit()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
    }
    
    func setViews(_ viewModels: [SendMoneyTransferTypeRadioButtonViewModel]) {
        guard !viewModels.isEmpty else { return }
        self.addSeparatorView()
        for (index, viewModel) in viewModels.enumerated() {
            self.addRadioButton(viewModel, index: index)
            self.addSeparatorView()
        }
    }
    
    func addRadioButton(_ viewModel: SendMoneyTransferTypeRadioButtonViewModel, index: Int) {
        var subviews: [UIView] = []
        subviews.append(self.getOneRadioButton(viewModel.oneRadioButtonViewModel, index: index))
        if let feeViewModel = viewModel.feeViewModel {
            subviews.append(self.getFeeView(feeViewModel, index: index))
        }
        let horizontalStackView = self.getHorizontalStackView(with: subviews)
        self.stackView.addArrangedSubview(horizontalStackView)
    }
    
    func getHorizontalStackView(with subviews: [UIView]) -> UIStackView {
        let horizontalStackView = UIStackView(arrangedSubviews: subviews)
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = Constants.HorizontalStackView.spacing
        return horizontalStackView
    }
    
    func getOneRadioButton(_ viewModel: OneRadioButtonViewModel, index: Int) -> OneRadioButtonView {
        let oneRadioButtonView = OneRadioButtonView()
        oneRadioButtonView.delegate = self
        oneRadioButtonView.setViewModel(viewModel, index: index)
        return oneRadioButtonView
    }
    
    func getFeeView(_ viewModel: SendMoneyTransferTypeFeeViewModel, index: Int) -> SendMoneyTransferTypeFeeView {
        let feeView = SendMoneyTransferTypeFeeView()
        feeView.delegate = self
        feeView.setViewModel(viewModel, index: index)
        return feeView
    }
    
    func addSeparatorView() {
        let separatorView = UIView()
        separatorView.backgroundColor = .oneMediumSkyGray
        separatorView.heightAnchor.constraint(equalToConstant: Constants.SeparatorView.height).isActive = true
        self.stackView.addArrangedSubview(separatorView)
    }
    
    func changeViewsStatus() {
        self.stackView.subviews.forEach {
            guard let horizontalStackView = $0 as? UIStackView else { return }
            horizontalStackView.subviews.forEach {
                self.setOneRadioButtonStatus($0)
                self.setFeeViewStatus($0)
            }
        }
    }
    
    func setOneRadioButtonStatus(_ view: UIView) {
        guard let view = view as? OneRadioButtonView,
              view.getStatus() != .disabled else { return }
        view.setByStatus(view.index == self.selectedIndex ? .activated : .inactive)
    }
    
    func setFeeViewStatus(_ view: UIView) {
        guard let view = view as? SendMoneyTransferTypeFeeView else { return }
        view.changeStatus(to: view.index == self.selectedIndex ? .activated : .inactive)
    }
    
    func didSelectTransferType(at index: Int) {
        self.selectedIndex = index
        self.changeViewsStatus()
        self.delegate?.didSelectRadioButton(at: index)
    }
}

extension SendMoneyTransferTypeRadioButtonsContainerView: OneRadioButtonViewDelegate {
    public func didSelectOneRadioButton(_ index: Int) {
        self.didSelectTransferType(at: index)
    }
    
    public func didTapTooltip() {
        self.delegate?.didTapTooltip()
    }
}

extension SendMoneyTransferTypeRadioButtonsContainerView: SendMoneyTransferTypeFeeViewDelegate {
    func didSelectFeeView(at index: Int) {
        self.didSelectTransferType(at: index)
    }
}
