//
//  Utils.swift
//  LittleLemon
//
//  Created by Carlos Martínez on 16/08/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.primary)
            .foregroundStyle(Color.onPrimary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension Color {
    
    static let primary = Color(red: 0.95, green: 0.8, blue: 0.07)
    static let secondary = Color(red: 0.28, green: 0.36, blue: 0.34)
    static let onPrimary = Color.black
    static let onSecondary = Color.white
}
