//
//  SupportConfiguration.swift
//  SupportKit
//
//  Created by Chingiz on 19.06.25.
//

import SwiftUI

public struct SupportConfiguration {
    public let title: String
    public let primaryColor: Color
    public let buttonStyle: ButtonStyle
    public let showCloseButton: Bool
    
    public enum ButtonStyle {
        case filled
        case bordered
        case plain
    }
    
    public init(
        title: String = "Support",
        primaryColor: Color = .blue,
        buttonStyle: ButtonStyle = .filled,
        showCloseButton: Bool = true
    ) {
        self.title = title
        self.primaryColor = primaryColor
        self.buttonStyle = buttonStyle
        self.showCloseButton = showCloseButton
    }
    
    // Pre-defined themes
    public static let `default` = SupportConfiguration()
    
    public static let minimal = SupportConfiguration(
        title: "Help",
        primaryColor: .gray,
        buttonStyle: .plain,
        showCloseButton: false
    )
    
    public static let brand = SupportConfiguration(
        title: "Contact Us",
        primaryColor: .purple,
        buttonStyle: .filled,
        showCloseButton: true
    )
}
