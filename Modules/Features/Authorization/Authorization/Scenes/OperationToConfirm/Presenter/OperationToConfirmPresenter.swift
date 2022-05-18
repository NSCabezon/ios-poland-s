//
//  OperationToConfirmPresenter.swift
//  Authorization
//
//  Created by 186484 on 14/04/2022.
//

import Operative
import PLCommons
import PLCommonOperatives
import CoreFoundationLib

let AUTHORIZATION_TOTAL_DURATION: TimeInterval = 180

protocol OperationToConfirmPresenterProtocol: AnyObject {
    var view: OperationToConfirmViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()

    func didSelectGoBack()
    func didSelectCloseProcess()
    func didSelectConfirmProcess()
}

final class OperationToConfirmPresenter {
    weak var view: OperationToConfirmViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: AuthorizationModuleCoordinatorProtocol?
    
    private let timer = TimerHandler()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(
            for: AuthorizationModuleCoordinatorProtocol.self
        )
    }
    
    func initializeTimer() {
        let remainingSeconds = AUTHORIZATION_TOTAL_DURATION
        startCountdown(totalDuration: AUTHORIZATION_TOTAL_DURATION, remainingDuration: remainingSeconds)
    }
}

extension OperationToConfirmPresenter: OperationToConfirmPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        resumePendingProgressAnimationIfNeeded()
        initializeTimer()
    }
    
    func resumePendingProgressAnimationIfNeeded() {
        guard timer.counter != 0 else { return }
        timer.stopTimer()
        view?.startProgressAnimation(
            totalDuration: AUTHORIZATION_TOTAL_DURATION,
            remainingDuration: TimeInterval(timer.counter)
        )
    }
    
    func startCountdown(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        timer.didUpdate = { [weak self] counter in
            self?.view?.updateCounter(remainingSeconds: counter)
            
            if (TimeInterval(counter) / totalDuration) <= 0.25 {
                // TODO: - Action before timer ends.
            }
        }
        
        timer.didEnd = { [weak self]  in
            self?.view?.handleTimerEndsProcess()
        }
        
        view?.startProgressAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
        timer.startTimer(duration: remainingDuration)
    }
    
    func didSelectGoBack() {
        coordinator?.close()
    }
    
    func didSelectCloseProcess() {
        coordinator?.close()
    }
    
    func didSelectConfirmProcess() {
        
    }
    
    private func showErrorView() {
        view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
            self?.coordinator?.close()
        })
    }
    
}
