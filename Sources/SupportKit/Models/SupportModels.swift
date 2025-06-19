//
//  SupportModels.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation

public enum FeedbackType: String, CaseIterable, Codable {
    case bug = "bug"
    case feedback = "feedback"
    case suggestion = "suggestion"
    
    public var displayName: String {
        switch self {
        case .bug:
            return "Bug Report"
        case .feedback:
            return "Feedback"
        case .suggestion:
            return "Suggestion"
        }
    }
}

public struct SupportFeedback: Codable {
    let id: String
    let email: String
    let feedbackType: FeedbackType
    let description: String
    let timestamp: Date
    
    public init(email: String, feedbackType: FeedbackType, description: String) {
        self.id = UUID().uuidString
        self.email = email
        self.feedbackType = feedbackType
        self.description = description
        self.timestamp = Date()
    }
}
