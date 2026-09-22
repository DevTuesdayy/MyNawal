import Foundation

nonisolated struct PostcardTextSettings: Codable, Equatable, Sendable {
    static let nameLimit = 28
    static let messageLimit = 64

    var personName = ""
    var message = ""
    var typography: PostcardTypography = .rounded
    var showsDate = true
    var showsAnimal = true
    var showsElement = true
    var showsEnergyAssociations = false

    var trimmedName: String {
        String(personName.prefix(Self.nameLimit))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var resolvedMessage: String {
        let value = String(message.prefix(Self.messageLimit))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? "Conecta con tu esencia  •  Honra tu origen" : value
    }
}

nonisolated enum PostcardTypography: String, Codable, CaseIterable, Identifiable, Sendable {
    case rounded, classic, clean

    var id: Self { self }

    var title: String {
        switch self {
        case .rounded: "Redondeada"
        case .classic: "Clásica"
        case .clean: "Limpia"
        }
    }
}
