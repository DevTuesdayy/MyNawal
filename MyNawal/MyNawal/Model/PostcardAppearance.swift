import Foundation

nonisolated struct PostcardAppearance: Equatable, Sendable {
    var design: PostcardDesign = .classic
    var thickness: PostcardFrameThickness = .medium
    var background: PostcardPaper = .cream
    var frameColor: PostcardInk? = nil
    var accentColor: PostcardInk? = nil
    var photo = PostcardPhotoSettings()

    mutating func apply(_ palette: PostcardPalette) {
        background = palette.paper
        frameColor = palette.ink
        accentColor = palette.ink
    }
}

nonisolated enum PostcardPaper: String, CaseIterable, Identifiable, Sendable {
    case cream, sand, jade, rose, stone, ivory
    var id: Self { self }
    var title: String {
        switch self {
        case .cream: "Crema"
        case .sand: "Arena"
        case .jade: "Jade suave"
        case .rose: "Arcilla suave"
        case .stone: "Piedra"
        case .ivory: "Marfil"
        }
    }
}

nonisolated enum PostcardInk: String, CaseIterable, Identifiable, Sendable {
    case jade, earth, red, slate, plum, charcoal
    var id: Self { self }
    var title: String {
        switch self {
        case .jade: "Jade"
        case .earth: "Tierra"
        case .red: "Rojo"
        case .slate: "Pizarra"
        case .plum: "Ciruela"
        case .charcoal: "Carbón"
        }
    }
}

nonisolated enum PostcardPalette: String, CaseIterable, Identifiable, Sendable {
    case jade, sand, cream, clay, stone, night
    var id: Self { self }
    var title: String {
        switch self {
        case .jade: "Jade"
        case .sand: "Arena"
        case .cream: "Crema"
        case .clay: "Arcilla"
        case .stone: "Piedra"
        case .night: "Tinta"
        }
    }
    var paper: PostcardPaper {
        switch self {
        case .jade: .jade
        case .sand: .sand
        case .cream: .cream
        case .clay: .rose
        case .stone: .stone
        case .night: .ivory
        }
    }
    var ink: PostcardInk {
        switch self {
        case .jade: .jade
        case .sand: .earth
        case .cream: .plum
        case .clay: .red
        case .stone: .slate
        case .night: .charcoal
        }
    }
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
