import Foundation

public struct HelpQuestionsDTO: Codable {
    public let mainWindowCategoryTitle: String
    public let sections: [Section]

    enum CodingKeys: String, CodingKey {
        case mainWindowCategoryTitle = "main-window-category-title"
        case sections
    }
    
    public struct Section: Codable {
        public let profiles: [String]
        public let questions: [Question]
        
    }
    
    public struct Question: Codable {
        public let name: String
        public let answer: String
    }
}


