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
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                }
                
                Section {
                    submitButton
                }
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
                }
            } message: {
                Text(viewModel.successMessage ?? "")
            }
        }
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
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(customButtonStyle)
        .disabled(viewModel.isSubmitting)
    }
    
    private var customButtonStyle: some PrimitiveButtonStyle {
        switch config.buttonStyle {
        case .filled:
            return FilledButtonStyle(color: config.primaryColor)
        case .bordered:
            return BorderedButtonStyle(color: config.primaryColor)
        case .plain:
            return PlainButtonStyle()
        }
    }
    
    private var buttonTextColor: Color {
        switch config.buttonStyle {
        case .filled:
            return .white
        case .bordered, .plain:
            return config.primaryColor
        }
    }
}

// Custom Button Styles
struct FilledButtonStyle: PrimitiveButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct BorderedButtonStyle: PrimitiveButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct PlainButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    SupportView()
}
