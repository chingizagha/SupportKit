//
//  SupportViewModel.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation
import Combine

internal class SupportViewModel: ObservableObject {
    @Published var email = ""
    @Published var selectedFeedbackType: FeedbackType = .feedback
    @Published var description = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let firebaseManager = SupportFirebaseManager()
    private var cancellables = Set<AnyCancellable>()
    
    func submitFeedback() {
        guard isFormValid else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        let feedback = SupportFeedback(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            feedbackType: selectedFeedbackType,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        firebaseManager.submitFeedback(feedback)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSubmitting = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Failed to submit: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] in
                    self?.successMessage = "Thank you! Your feedback has been submitted."
                    self?.clearForm()
                }
            )
            .store(in: &cancellables)
    }
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        email.contains("@")
    }
    
    private func clearForm() {
        email = ""
        description = ""
        selectedFeedbackType = .feedback
    }
}
