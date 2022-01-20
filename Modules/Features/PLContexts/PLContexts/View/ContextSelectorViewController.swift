//
//  ContextSelectorViewController.swift
//  PLUI
//
//  Created by Ernesto Fernandez Calles on 22/12/21.
//

import UIKit
import UI
import Commons
import SANPLLibrary

protocol ContextSelectorViewProtocol: GenericErrorDialogPresentationCapable {
    func setupUI(with contexts: [ContextSelectorViewModel])
}

final class ContextSelectorViewController: UIViewController {

    lazy var backgroundDimmingView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let contextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let contextTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "ContextSelectorCell", bundle: .module), forCellReuseIdentifier: "ContextSelectorCell")
        table.separatorStyle = .none
        return table
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Assets.image(named: "icnClose")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lisboaGray
        return button
    }()

    let handle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let decoratorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var isShowingAllContexts = false
    var isPresenting = false
    var contextHeight: CGFloat = 0
    let dismissibleHeight = Constants.contextViewDismissableHeight
    var currentContainerHeight: CGFloat = 0

    var contextViewHeightConstraint: NSLayoutConstraint?

    var presenter: ContextSelectorPresenterProtocol

    private var contextViewModels: [ContextSelectorViewModel] = []

    init(nibName: String?, bundle: Bundle?, presenter: ContextSelectorPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nibName, bundle: bundle)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewHasLoad()
    }

    @objc func handleCloseAction() {
        self.presenter.didCancel()
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newHeight = currentContainerHeight - translation.y

        switch gesture.state {
        case .changed:
            if newHeight < contextHeight {
                contextViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                handleCloseAction()
            }
            else if newHeight < contextHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContextViewHeight(contextHeight)
            }
        default:
            break
        }
    }

    func animateContextViewHeight(_ height: CGFloat) {
        UIView.animate(withDuration: Constants.contextAnimationDuration) {
            self.contextViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

}

// MARK: - Extensions

// MARK: - Private methods

private extension ContextSelectorViewController {
    private func setupView() {
        contextHeight = contextViewHeight()
        currentContainerHeight = contextViewHeight()
        view.backgroundColor = .clear
        contextView.backgroundColor = .white
        contextView.layer.cornerRadius = 16
        decoratorView.backgroundColor = .white
        handle.backgroundColor = .mediumSkyGray
        handle.layer.cornerRadius = 3
        contextTable.delegate = self
        contextTable.dataSource = self
        contextTable.alwaysBounceVertical = false
        closeButton.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        backgroundDimmingView.addGestureRecognizer(tapGesture)
    }

    private func setupLabels() {
        let font = UIFont(name: "SantanderHeadline-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lisboaGray]
        self.titleLabel.attributedText = NSAttributedString(string: localized("pl_context_label_changeContext"), attributes: attributes)
        self.titleLabel.sizeToFit()
    }

    private func setupLayout() {
        view.addSubview(backgroundDimmingView)
        view.addSubview(contextView)
        view.addSubview(closeButton)
        view.addSubview(handle)
        view.addSubview(titleLabel)
        contextView.addSubview(contextTable)
        contextView.addSubview(decoratorView)

        NSLayoutConstraint.activate([
            backgroundDimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundDimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundDimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundDimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.topAnchor.constraint(equalTo: contextView.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: contextView.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            handle.widthAnchor.constraint(equalToConstant: 28),
            handle.heightAnchor.constraint(equalToConstant: 4),
            handle.centerXAnchor.constraint(equalTo: contextView.centerXAnchor),
            handle.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contextView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 20),

            contextTable.leadingAnchor.constraint(equalTo: contextView.leadingAnchor),
            contextTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contextTable.trailingAnchor.constraint(equalTo: contextView.trailingAnchor),
            contextTable.bottomAnchor.constraint(equalTo: contextView.bottomAnchor),

            decoratorView.leadingAnchor.constraint(equalTo: contextView.leadingAnchor),
            decoratorView.topAnchor.constraint(equalTo: contextView.safeAreaLayoutGuide.bottomAnchor),
            decoratorView.trailingAnchor.constraint(equalTo: contextView.trailingAnchor),
            decoratorView.bottomAnchor.constraint(equalTo: contextView.bottomAnchor),
        ])

        contextViewHeightConstraint = contextView.heightAnchor.constraint(equalToConstant: contextHeight)
        contextViewHeightConstraint?.isActive = true
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        contextView.addGestureRecognizer(panGesture)
    }

    private enum Constants {
        static let contextViewDismissableHeight: CGFloat = 200
        static let contextAnimationDuration: TimeInterval = 0.4
        static let cellHeight: CGFloat = 88
        static let footerHeight: CGFloat = 44
        static let maxCellsInCompactMode = 4
    }

    private func needsToShowFooter() -> Bool {
        return (self.contextViewModels.count > Constants.maxCellsInCompactMode) && (!isShowingAllContexts)
    }

    private func contextViewHeight() -> CGFloat {
        var height: CGFloat = 140
        if self.contextViewModels.count > Constants.maxCellsInCompactMode {
            height = height + (CGFloat(Constants.maxCellsInCompactMode) * Constants.cellHeight) + Constants.footerHeight
        } else {
            height = height + (CGFloat(self.contextViewModels.count) * Constants.cellHeight)
        }
        return height
    }

    private func setAccessibilityIdentifiers() {
        self.titleLabel.accessibilityIdentifier = AccessibilityContext.lblTitle
        self.closeButton.accessibilityIdentifier = AccessibilityContext.btnClose
    }
}

// MARK: - ContextSelectorViewProtocol

extension ContextSelectorViewController: ContextSelectorViewProtocol {
    func setupUI(with contexts: [ContextSelectorViewModel]) {
        self.contextViewModels = contexts
        setupView()
        setupLabels()
        setupLayout()
        setupPanGesture()
        setAccessibilityIdentifiers()
    }
}

// MARK: - UITableViewDelegate, UITAbleViewDataSource

extension ContextSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.needsToShowFooter() {
            return Constants.maxCellsInCompactMode
        } else {
            return self.contextViewModels.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextSelectorCell", for: indexPath) as! ContextSelectorCell
        cell.setup(with: self.contextViewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectContext(with: self.contextViewModels[indexPath.row].ownerId)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.needsToShowFooter(), let contextSelectorFooterView = UINib(nibName: "ContextSelectorFooterView", bundle: .module).instantiate(withOwner: nil, options: nil)[0] as? ContextSelectorFooterView {
            contextSelectorFooterView.delegate = self
            contextSelectorFooterView.configure(self.contextViewModels.count - Constants.maxCellsInCompactMode)
            return contextSelectorFooterView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        decoratorView.isHidden = !self.needsToShowFooter()
        return self.needsToShowFooter() ? Constants.footerHeight : 0
    }
}

// MARK: - UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning

extension ContextSelectorViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        toViewController.view.frame = transitionContext.containerView.frame
        isPresenting = !isPresenting

        if isPresenting {
            containerView.addSubview(toViewController.view)

            contextView.frame.origin.y += contextHeight
            closeButton.frame.origin.y += contextHeight
            handle.frame.origin.y += contextHeight
            titleLabel.frame.origin.y += contextHeight

            backgroundDimmingView.alpha = 0

            UIView.animate(withDuration: Constants.contextAnimationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.contextView.frame.origin.y -= self.contextHeight
                self.closeButton.frame.origin.y -= self.contextHeight
                self.handle.frame.origin.y -= self.contextHeight
                self.titleLabel.frame.origin.y -= self.contextHeight
                self.backgroundDimmingView.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: Constants.contextAnimationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.contextView.frame.origin.y += self.contextHeight
                self.closeButton.frame.origin.y += self.contextHeight
                self.handle.frame.origin.y += self.contextHeight
                self.titleLabel.frame.origin.y += self.contextHeight
                self.backgroundDimmingView.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}

// MARK: - ContextSelectorFooterViewDelegate

extension ContextSelectorViewController: ContextSelectorFooterViewDelegate {
    func didTapShowAllContexts() {
        self.presenter.didShowAllContexts()
        self.isShowingAllContexts = true
        self.contextTable.reloadData()
    }
}
