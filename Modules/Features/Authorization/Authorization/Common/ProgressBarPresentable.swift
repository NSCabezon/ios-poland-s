//
//  ProgressBarPresentable.swift
//  Authorization
//
//  Created by 186484 on 25/04/2022.
//

import UI

protocol ProgressBarPresentable: AnyObject {
    var progressBar: ProgressBar { get }
    var animator: UIViewPropertyAnimator? { get set }
}

extension ProgressBarPresentable {
    func startProgressBarAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        animator?.stopAnimation(true)
        
        let elapsed = (totalDuration - remainingDuration) / totalDuration
        let remaining = 1 - elapsed
        
        progressBar.layoutIfNeeded()
        progressBar.setProgressPercentage(CGFloat(remaining) * 100)
        progressBar.layoutIfNeeded()
        
        animator = UIViewPropertyAnimator(duration: remainingDuration, curve: .linear) {
            self.progressBar.setProgressPercentage(0)
            self.progressBar.layoutIfNeeded()
        }
        animator?.startAnimation()
    }
}

extension ProgressBar {
    func setRoundedCorners() {
        let cornerRadius = frame.height / 2
        layer.cornerRadius = cornerRadius
        subviews.forEach {
            $0.layer.cornerRadius = cornerRadius
            $0.subviews.forEach {
                $0.layer.cornerRadius = cornerRadius
            }
        }
    }
}
