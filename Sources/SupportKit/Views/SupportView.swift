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
    
    private var config: SupportConfiguration {
        SupportKit.currentConfiguration
    }
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                }
                
                Section(header: Text("Feedback Type")) {
                    Picker("Type", selection: $viewModel.selectedFeedbackType) {
                        ForEach(FeedbackType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accentColor(config.primaryColor)
                }
                
                Section(header: Text("Description")) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 100)
                        
                        if viewModel.description.isEmpty {
                            Text("Please describe your feedback or issue...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                    }
                }
                
                Section {
                    submitButton
                }
            }
            .navigationTitle(config.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: config.showCloseButton ? closeButton : nil)
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
        }
        .interactiveDismissDisabled(viewModel.isSubmitting)
    }
    
    private var closeButton: some View {
        Button("Close") {
            dismiss()
        }
        .foregroundColor(config.primaryColor)
    }
    
    @ViewBuilder
    private var submitButton: some View {
        Button(action: {
            viewModel.submitFeedback()
        }) {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .scaleEffect(0.8)
                        .foregroundColor(buttonTextColor)
                }
                Text(viewModel.isSubmitting ? "Submitting..." : "Submit Feedback")
                    .foregroundColor(buttonTextColor)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(CustomButtonStyle(config: config))
        .disabled(viewModel.isSubmitting || !isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
    }
    
    private var buttonTextColor: Color {
        switch config.buttonStyle {
        case .filled:
            return .white
        case .bordered, .plain:
            return config.primaryColor
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !viewModel.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        viewModel.email.contains("@")
    }
}

// Single custom button style
struct CustomButtonStyle: ButtonStyle {
    let config: SupportConfiguration
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundView)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch config.buttonStyle {
        case .filled:
            RoundedRectangle(cornerRadius: 8)
                .fill(config.primaryColor)
        case .bordered:
            RoundedRectangle(cornerRadius: 8)
                .stroke(config.primaryColor, lineWidth: 2)
        case .plain:
            EmptyView()
        }
    }
}

#Preview {
    SupportView()
}
