import Foundation

public struct HelpQuestionsDTO: Codable {
    
    public let checkInterval: Int
    public let categoryByLanguage: [String: Category]
    
    enum CodingKeys: String, CodingKey {
        case checkInterval = "check-interval"
        case categoryByLanguage = "category-by-language"
    }
}

public extension HelpQuestionsDTO {
    //TODO: - ask BE what optional values they return, the question was added in [MOBILE-7881]
    
    struct Category: Codable {
        public let mainWindowCategoryTitle: String
        public let isDefault: Bool
        public let sections: [Section]
        
        enum CodingKeys: String, CodingKey {
            case mainWindowCategoryTitle = "main-window-category-title"
            case isDefault = "is-default"
            case sections
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            mainWindowCategoryTitle = try values.decode(String.self, forKey: .mainWindowCategoryTitle)
            if let stringValue = try values.decodeIfPresent(String.self, forKey: .isDefault),
               let boolValue = Bool(stringValue) {
                isDefault = boolValue
            } else {
                isDefault = false
            }
            sections = try values.decodeIfPresent([Section].self, forKey: .sections) ?? []
        }
    }
    
    struct Section: Codable {
        public let profiles: [HelpCenterClientProfile]
        public let questions: [Question]
    }
    
    struct Question: Codable {
        public let name: String
        public let answer: String
    }
    
}
