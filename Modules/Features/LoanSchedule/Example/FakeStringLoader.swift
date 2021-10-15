import Foundation
import Commons
import Models

typealias CurrentLanguageProvider = () -> String

final class FakeStringLoader: StringLoader {
    
    private let currentLanguageProvider: CurrentLanguageProvider
    
    init(currentLanguageProvider: @escaping CurrentLanguageProvider) {
        self.currentLanguageProvider = currentLanguageProvider
    }
    
    func updateCurrentLanguage(language: Language) {
        fatalError()
    }
    
    func getCurrentLanguage() -> Language {
        let languageType = LanguageType(rawValue: currentLanguageProvider()) ?? .english
        return Language.createFromType(languageType: languageType, isPb: nil)
    }
    
    func getString(_ key: String) -> LocalizedStylableText {
        fatalError()
    }
    
    func getString(_ key: String, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getQuantityString(_ key: String, _ count: Int, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getQuantityString(_ key: String, _ count: Double, _ stringPlaceholders: [StringPlaceholder]) -> LocalizedStylableText {
        fatalError()
    }
    
    func getWsErrorString(_ key: String) -> LocalizedStylableText {
        fatalError()
    }
    
    func getWsErrorIfPresent(_ key: String) -> LocalizedStylableText? {
        fatalError()
    }
    
    func getWsErrorWithNumber(_ key: String, _ phone: String) -> LocalizedStylableText {
        fatalError()
    }
}
    
