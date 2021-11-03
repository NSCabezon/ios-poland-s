//
//  SegmentedPageViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 16/06/2021.
//

import UIKit
import UI

public class SegmentedPageViewController: UIViewController {
    private let segmentedControl = LisboaSegmentedControl(frame: .zero)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pagedControllers: [PagedController]
    
    public init(
        pagedControllers: [PagedController]
    ) {
        self.pagedControllers = pagedControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        configureSegmentedControl()
        configureSubviews()
        configurePageViewController()
        applyStyling()
    }
    
    private func configureSegmentedControl() {
        let keys = pagedControllers.map { $0.title }
        segmentedControl.setup(with: keys)
        segmentedControl.addTarget(
            self,
            action: #selector(didSelectSegment(_:)),
            for: .valueChanged
        )
    }
    
    private func configureSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        didMove(toParent: pageViewController)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configurePageViewController() {
        guard let controller = pagedControllers.first?.controller else { return }
        pageViewController.setViewControllers(
            [controller],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
    private func applyStyling() {
        view.backgroundColor = .white
    }
    
    @objc func didSelectSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard
            let selectedKey = sender.titleForSegment(at: selectedIndex),
            let controllerToShow = pagedControllers.first(where: { $0.title == selectedKey })?.controller,
            let currentController = pageViewController.viewControllers?.first
        else {
            return
        }
        
        let currentControllerIndex = pagedControllers.enumerated().first(where: {
            $0.element.controller == currentController
        })?.offset
        guard let currentIndex = currentControllerIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = {
            if selectedIndex > currentIndex {
                return .forward
            } else {
                return .reverse
            }
        }()
        
        pageViewController.setViewControllers(
            [controllerToShow],
            direction: direction,
            animated: true,
            completion: nil
        )
    }
}

public extension SegmentedPageViewController {
    struct PagedController {
        let title: String
        let controller: UIViewController
    }
}
