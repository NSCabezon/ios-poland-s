import Foundation
import SANPLLibrary

struct HelpCenterConfig {
    let sections: [Section]
}

extension HelpCenterConfig {
    
    enum SectionType {
        // Main - Dashboard - When User is Logged in
        case hints(title: String) // Questions and answers
        case inAppActions
        case call
        case onlineAdvisor
        case mail
        
        // Main - Contact - When User is Logged out
        case contact
        
        // Additional - Conversation Topic
        case conversationTopic
    }
    
    struct Section {
        let section: SectionType
        let elements: [Element]
    }
    
    enum Element {
        // Dashboard & Contact
        case blockCard
        case yourCases
        case mailContact
        case call(phoneNumber: String)
        case advisor(name: String, iconUrl: String, details: AdvisorDetails)
        case expandableHint(question: String, answer: String)
        case info(message: String)
        
        // Conversation Topic
        case subject(details: SubjectDetails)
    }
    
    struct AdvisorDetails {
        let mediumType: MediumType
        let subjects: [SubjectDetails]
        let baseAddress: String
        let iconBaseAddress: String
    }

    struct SubjectDetails {
        let name: String
        let entryType: String
        let subjectId: String
        let iconUrl: String
        let loginActionRequired: Bool 
    }
        
    typealias MediumType = OnlineAdvisorDTO.MediumType
    
}
