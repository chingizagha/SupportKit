//
//  FeedbackTypeSelector.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import SwiftUI

struct FeedbackTypeSelector: View {
    
    @Binding var feedbackType: FeedbackType
    let config: SupportConfiguration
    
    var body: some View {
        Menu {
            ForEach(FeedbackType.allCases) { feedback in
                Button(action: {
                    feedbackType = feedback
                }) {
                    HStack {
                        Image(systemName: feedback.icon)
                        Text(feedback.name)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: feedbackType.icon)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Text(feedbackType.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(config.primaryColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(config.primaryColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}
