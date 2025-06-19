//
//  SupportFirebaseProtocol.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import Foundation
import Combine

public protocol SupportFirebaseProtocol {
    func submitFeedback(_ feedback: SupportFeedback) -> AnyPublisher<Void, Error>
}
