import SwiftUI
import Combine

public struct SupportKit {
    
    private static var configuration = SupportConfiguration.default
    
    /// Configure SupportKit with custom appearance
    public static func configure(_ config: SupportConfiguration = .default) {
        self.configuration = config
    }
    
    /// Get current configuration (internal use)
    internal static var currentConfiguration: SupportConfiguration {
        return configuration
    }
    
    /// Present support view with current configuration
    public static func presentSupport() -> SupportView {
        return SupportView()
    }
    
    /// Submit feedback programmatically without UI
    public static func submitFeedback(
        email: String,
        type: FeedbackType,
        description: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let feedback = SupportFeedback(
            email: email,
            feedbackType: type,
            description: description
        )
        
        let manager = SupportFirebaseManager()
        var cancellable: AnyCancellable?
        
        cancellable = manager.submitFeedback(feedback)
            .sink(
                receiveCompletion: { result in
                    cancellable?.cancel()
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: {
                    completion(.success(()))
                }
            )
    }
}
