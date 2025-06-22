//
//  FeedbackTypeSelector.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//


//import SwiftUI
//
//struct FeedbackTypeSelector: View {
//
//    @Binding var feedbackType: FeedbackType
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            // Label
//            Text("Feedback Type")
//                .font(.system(size: 11, weight: .medium))
//                .foregroundColor(.gray)
//                .lineLimit(1)
//
//            Menu {
//                ForEach(FeedbackType.allCases) { feedback in
//                    Button(action: {
//                            feedbackType = feedback
//                    }) {
//                        HStack {
//                            Image(systemName: feedback.icon)
//
//                            Text(feedback.name)
//                        }
//                        .lineLimit(nil)
//                    }
//                }
//            } label: {
//                HStack(spacing: 4) {
//
//                    Image(systemName: feedbackType.icon)
//                        .font(.system(size: 14))
//
//
//                    Text(feedbackType.name)
//                        .font(.system(size: 14, weight: .semibold))
////                        .foregroundColor(.primaryBlue)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.7)
//
//                    Spacer(minLength: 2)
//
//                    Image(systemName: "chevron.down")
//                        .font(.system(size: 10))
////                        .foregroundColor(.primaryBlue)
//                }
////                .padding(.horizontal, 8)
////                .padding(.vertical, 8)
//                .frame(height: 36)
////                .background(
////                    Capsule()
////                        .fill(Color.secondaryBlue.opacity(0.12))
////                )
////                .overlay(
////                    Capsule()
////                        .stroke(Color.primaryBlue.opacity(0.2), lineWidth: 1)
////                )
//            }
//        }
//    }
//}

//#Preview {
//    FeedbackTypeSelector(feedbackType: .constant(.bug))
//}


