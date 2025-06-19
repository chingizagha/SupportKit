import SwiftUI
import Combine

public protocol SupportFirebaseProtocol {
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error>
}



public struct SupportKit {
    private static var configuration = SupportConfiguration.default
    private static var firebaseProvider: SupportFirebaseProtocol?
    
    /// Configure SupportKit with Firebase provider
    public static func configure(
        firebaseProvider: SupportFirebaseProtocol,
        configuration: SupportConfiguration = .default
    ) {
        self.firebaseProvider = firebaseProvider
        self.configuration = configuration
    }
    
    /// Configure with predefined theme (requires prior Firebase setup)
    public static func configure(_ config: SupportConfiguration = .default) {
        guard firebaseProvider != nil else {
            fatalError("Must configure Firebase provider first. Call SupportKit.configure(firebaseProvider:) first.")
        }
        self.configuration = config
    }
    
    /// Get current configuration
    internal static var currentConfiguration: SupportConfiguration {
        return configuration
    }
    
    /// Get Firebase provider
    internal static var currentFirebaseProvider: SupportFirebaseProtocol? {
        return firebaseProvider
    }
    
    /// Present support view
    public static func presentSupport() -> SupportView {
        guard firebaseProvider != nil else {
            fatalError("SupportKit not configured. Call SupportKit.configure(firebaseProvider:) first.")
        }
        return SupportView()
    }
    
    /// Submit feedback programmatically
    public static func submitFeedback(
        email: String,
        type: FeedbackType,
        description: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let provider = firebaseProvider else {
            completion(.failure(SupportKitError.notConfigured))
            return
        }
        
        let feedback = SupportFeedback(
            email: email,
            feedbackType: type,
            description: description
        )
        
        let manager = SupportFirebaseManager(provider: provider)
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

public enum SupportKitError: Error {
    case notConfigured
    
    public var localizedDescription: String {
        switch self {
        case .notConfigured:
            return "SupportKit not configured. Call SupportKit.configure(firebaseProvider:) first."
        }
    }
}
