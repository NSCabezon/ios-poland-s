//
//  HelpQuestionsInfo.swift
//  SANPLLibrary
//

import Foundation

//TODO: - ask BE what optional values they return, the question was added in [MOBILE-7881]
public struct HelpQuestionsInfo: Codable {
    public var helpQuestions: HelpQuestionsDTO?
    public var helpQuestionsStoreDate: Date?
}
