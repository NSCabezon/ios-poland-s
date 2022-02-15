//
//  PLOnboardingConfiguration.swift
//  Santander
//
//  Created by Jose Camallonga on 4/2/22.
//

import Foundation
import Onboarding
import UI

struct PLOnboardingConfiguration: OnboardingConfiguration {
    var allowAbort: Bool {
        return true
    }
    
    var numCountableSteps: Int {
        return 4
    }
    
    var steps: [StepsCoordinator<OnboardingStep>.Step] {
        return [StepsCoordinator<OnboardingStep>.Step(type: .welcome),
                StepsCoordinator<OnboardingStep>.Step(type: .changeAlias, state: .disabled),
                StepsCoordinator<OnboardingStep>.Step(type: .languages),
                StepsCoordinator<OnboardingStep>.Step(type: .options),
                StepsCoordinator<OnboardingStep>.Step(type: .selectPG),
                StepsCoordinator<OnboardingStep>.Step(type: .photoTheme),
                StepsCoordinator<OnboardingStep>.Step(type: .final)]
    }
}
