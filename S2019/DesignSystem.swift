//
//  DesignSystem.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

// MARK: - Color Scheme
extension Color {
    static let gemPathBackground = Color(hex: "3B2A1A")
    static let gemPathGoldStart = Color(hex: "F8C76B")
    static let gemPathGoldEnd = Color(hex: "E2A540")
    static let gemPathEmerald = Color(hex: "4AC06B")
    static let gemPathGoldBorder = Color(hex: "D4A950")
    static let gemPathRuby = Color(hex: "D93F3F")
    static let gemPathText = Color(hex: "FDF7E5")
    
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

// MARK: - Gradients
extension LinearGradient {
    static let gemPathGolden = LinearGradient(
        gradient: Gradient(colors: [Color.gemPathGoldStart, Color.gemPathGoldEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gemPathBackground = LinearGradient(
        gradient: Gradient(colors: [Color.gemPathBackground, Color.gemPathBackground.opacity(0.8)]),
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Button Styles
struct GemPathButtonStyle: ButtonStyle {
    let color: Color
    let textColor: Color
    
    init(color: Color = .gemPathEmerald, textColor: Color = .gemPathText) {
        self.color = color
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gemPathGoldBorder, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct GemPathCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gemPathBackground.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gemPathGoldBorder.opacity(0.5), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
            )
    }
}

extension View {
    func gemPathCard() -> some View {
        modifier(GemPathCardStyle())
    }
}

// MARK: - Gem Icons
enum GemType: String, CaseIterable {
    case diamond = "diamond.fill"
    case circle = "circle.fill"
    case triangle = "triangle.fill"
    case square = "square.fill"
    case star = "star.fill"
    case heart = "heart.fill"
    case hexagon = "hexagon.fill"
    case pentagon = "pentagon.fill"
    case octagon = "octagon.fill"
    
    var color: Color {
        switch self {
        case .diamond: return .blue
        case .circle: return .red
        case .triangle: return .green
        case .square: return .orange
        case .star: return .yellow
        case .heart: return .pink
        case .hexagon: return .purple
        case .pentagon: return .cyan
        case .octagon: return .mint
        }
    }
}

