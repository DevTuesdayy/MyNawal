import Foundation

nonisolated struct PostcardAppearance: Equatable, Sendable {
    var design: PostcardDesign = .classic
    var thickness: PostcardFrameThickness = .medium
}

nonisolated enum PostcardDesign: String, CaseIterable, Identifiable, Sendable {
    case classic, stone, woven, minimal
    var id: Self { self }
    var title: String {
        switch self {
        case .classic: "Clásico"
        case .stone: "Piedra clara"
        case .woven: "Líneas de tejido"
        case .minimal: "Minimalista"
        }
    }
}

nonisolated enum PostcardFrameThickness: String, CaseIterable, Identifiable, Sendable {
    case fine, medium, bold
    var id: Self { self }
    var title: String {
        switch self {
        case .fine: "Fino"
        case .medium: "Medio"
        case .bold: "Grueso"
        }
    }
    var width: Double {
        switch self {
        case .fine: 1.5
        case .medium: 3
        case .bold: 5
        }
    }
}
