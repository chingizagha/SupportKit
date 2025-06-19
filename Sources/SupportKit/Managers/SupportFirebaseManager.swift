//
//  SupportFirebaseManager.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation
import FirebaseFirestore
import Combine

internal class SupportFirebaseManager {
    private let db = Firestore.firestore()
    
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let feedbackData = try Firestore.Encoder().encode(feedback)
                
                self.db.collection("support_feedback").document(feedback.id).setData(feedbackData) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
