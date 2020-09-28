//
//  Color+Extension.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 06/06/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import SwiftUI

// MARK: - Initializers
extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Color Style
extension Color {
    
    struct Style {
        
        static let grayLight = Color("GrayLight")
        static let gray = Color("Gray")
        static let grayDark = Color("GrayDark")
        
        static let blue = Color("Blue")
        static let blueLight = Color("BlueLight")
        static let blueFade = Color("BlueFade")
        
        static let red = Color("Red")
    }
}
