//
//  TimeImageAndGreetingViewModel.swift
//  PLLogin

import Foundation
import UIKit
import Models
import UI

enum Greeting: String {
    case goodMorning = "login_label_goodMornig"
    case goodAfternoon = "login_label_goodAfternoon"
    case goodNight = "login_label_goodEvening"
}

final class TimeImageAndGreetingViewModel {
    var greetingTextKey: Greeting {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let parts = calendar.dateComponents([.hour], from: now)
        switch parts.hour! {
        case 6..<12:
            return .goodMorning
        case 12..<19:
            return .goodAfternoon
        default:
            return .goodNight
        }
    }
    
    var backgroundImage: UIImage? {
        let randomId: Int = Int.random(in: 1...10)
        let theme: BackgroundImagesTheme = BackgroundImagesTheme.nature
        return UIImage(named: "\(theme.name)_\(randomId)", in: Bundle(for: Self.self), compatibleWith: nil)
    }
}
