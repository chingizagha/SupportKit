//
//  SupportView.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import SwiftUI

public struct SupportView: View {
    
    @StateObject private var viewModel = SupportViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private var config: SupportConfiguration {
        SupportKit.currentConfiguration
    }
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Simple header
                    VStack(spacing: 8) {
                        Text("How can we help?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Share your feedback or report an issue")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Form fields
                    VStack(spacing: 20) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            TextField("", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                        }
                        
                        // Feedback type
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feedback Type")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            FeedbackTypeSelector(feedbackType: $viewModel.selectedFeedbackType, config: config)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                                    )
                                    .frame(minHeight: 100)
                                
                                TextEditor(text: $viewModel.description)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                
                                if viewModel.description.isEmpty {
                                    Text("Tell us more about your feedback...")
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
            }
            
            // Submit button at bottom
            VStack {
                Divider()
                
                Button(action: {
                    viewModel.submitFeedback()
                }) {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        }
                        Text(viewModel.isSubmitting ? "Submitting..." : "Submit Feedback")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(isFormValid ? config.primaryColor : Color.gray)
                    )
                }
                .disabled(viewModel.isSubmitting || !isFormValid)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
        }
        .navigationTitle(config.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if config.showCloseButton {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(config.primaryColor)
                }
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Success", isPresented: .constant(viewModel.successMessage != nil)) {
            Button("OK") {
                viewModel.successMessage = nil
                dismiss()
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
        .interactiveDismissDisabled(viewModel.isSubmitting)
    }
    
    private var isFormValid: Bool {
        !viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        viewModel.email.contains("@")
    }
}

// MARK: - Updated FeedbackTypeSelector
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

#Preview {
    NavigationStack {
        SupportView()
    }
}
