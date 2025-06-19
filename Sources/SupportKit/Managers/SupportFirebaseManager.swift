//
//  SupportFirebaseProtocol.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation
import Combine

internal class SupportFirebaseManager {
    private let provider: SupportFirebaseProtocol
    
    init(provider: SupportFirebaseProtocol) {
        self.provider = provider
    }
    
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error> {
        return provider.submitFeedback(feedback)
    }
}

