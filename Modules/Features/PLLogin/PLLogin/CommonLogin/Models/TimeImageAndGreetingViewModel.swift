//
//  TimeImageAndGreetingViewModel.swift
//  PLLogin

import Foundation
import UIKit
import CoreFoundationLib
import UI

enum Greeting: String {
    case goodMorning = "login_label_goodMornig"
    case goodAfternoon = "login_label_goodAfternoon"
    case goodNight = "login_label_goodEvening"
}

final class TimeImageAndGreetingViewModel {
    
    static let shared = TimeImageAndGreetingViewModel()
    
    private var themeType: PLRememberedLoginBackgroundType?
    private let backgroundMinId: Int = 1
    private let backgroundMaxId: Int = 10
    private let defaultTheme: BackgroundImagesTheme = .nature
    private lazy var randomId: Int = {
        return Int.random(in: self.backgroundMinId...self.backgroundMaxId)
    }()
    
    var greetingTextKey: Greeting {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let parts = calendar.dateComponents([.hour], from: now)
        switch parts.hour! {
        case 3..<12:
            return .goodMorning
        case 12..<19:
            return .goodAfternoon
        default:
            return .goodNight
        }
    }

    private var backgroundImage: UIImage? {
        guard let type = themeType else { return nil }
        switch type {
        case .assets(let name):
            return UIImage(named: name, in: Bundle(for: TimeImageAndGreetingViewModel.self), compatibleWith: nil)
        case .documents(let data):
            guard let data = data else { return nil }
            return UIImage(data: data)
        }
    }
    
    public func getBackground() -> UIImage {
        return backgroundImage ?? UIImage(named: "\(defaultTheme.name)_\(randomId)", in: Bundle(for: TimeImageAndGreetingViewModel.self), compatibleWith: nil) ?? UIImage()
    }
    
    public func setThemeType(_ theme: BackgroundImagesTheme?, resolver: DependenciesResolver) {
        let theme = theme ?? defaultTheme
        guard theme.isLocalTheme == false else {
            self.themeType = .assets(name: "\(theme.name)_\(randomId)")
            return
        }
        let _: BackgroundImageManagerProtocol = resolver.resolve()
        let getBackgroundImageRepository: GetBackgroundImageRepositoryProtocol = resolver.resolve()
        let images: [Data] = getBackgroundImageRepository.get(theme.name)
        guard images.count > backgroundMaxId - backgroundMinId else {
            self.themeType = .documents(data: nil)
            return
        }
        let index: Int = randomId - backgroundMinId
        self.themeType = .documents(data: images[index])
    }
}
