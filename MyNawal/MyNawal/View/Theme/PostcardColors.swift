import SwiftUI

extension PostcardPaper {
    var color: Color {
        switch self {
        case .cream: .mamBlanco
        case .sand: Color(red: 0.94, green: 0.86, blue: 0.72)
        case .jade: Color(red: 0.85, green: 0.93, blue: 0.87)
        case .rose: Color(red: 0.96, green: 0.87, blue: 0.83)
        case .stone: Color(red: 0.90, green: 0.91, blue: 0.90)
        case .ivory: Color(red: 0.98, green: 0.96, blue: 0.90)
        }
    }
}

extension PostcardInk {
    var color: Color {
        switch self {
        case .jade: .mamJade
        case .earth: Color(red: 0.36, green: 0.25, blue: 0.14)
        case .red: .mamRojo
        case .slate: .mamAzul
        case .plum: .mamMorado
        case .charcoal: Color(red: 0.18, green: 0.21, blue: 0.20)
        }
    }
}

extension PostcardAppearance {
    var accent: Color { accentColor?.color ?? .mamJade }
    var border: Color { frameColor?.color ?? (design == .stone ? .mamArena : .mamFondo) }
    var ornament: Color { accentColor?.color ?? .mamAmarillo }
}
