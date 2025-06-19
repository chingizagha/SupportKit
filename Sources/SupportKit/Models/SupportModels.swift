//
//  SupportModels.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation

public enum FeedbackType: String, CaseIterable, Identifiable, Codable {

    case bug = "bug"
    case feedback = "feedback"
    case suggestion = "suggestion"
    
    public var id: String { self.rawValue }
    
    public var name: String {
        switch self {
        case .bug:
            return "Bug Report"
        case .feedback:
            return "Feedback"
        case .suggestion:
            return "Suggestion"
        }
    }
    
    public var icon: String {
        switch self {
        case .bug:
            "ant"
        case .feedback:
            "pencil"
        case .suggestion:
            "lightbulb"
        }
    }
}

public struct SupportFeedback: Codable {
    public let id: String
    public let email: String
    public let feedbackType: FeedbackType
    public let description: String
    public let timestamp: Date
    
    public init(email: String, feedbackType: FeedbackType, description: String) {
        self.id = UUID().uuidString
        self.email = email
        self.feedbackType = feedbackType
        self.description = description
        self.timestamp = Date()
    }
}
