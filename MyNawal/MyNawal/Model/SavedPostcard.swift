import Foundation

/// A snapshot, not a lookup into today's catalog: reopening keeps the original result.
nonisolated struct SavedPostcard: Codable, Identifiable, Equatable, Sendable {
    let schemaVersion: Int
    let id: UUID
    let createdAt: Date
    let draft: NawalPostcardDraft
    let appearance: PostcardAppearance
}

nonisolated enum PostcardAsset: String, Sendable {
    case selfie = "selfie.image"
    case rendered = "postcard.png"
    case thumbnail = "thumbnail.png"
}

nonisolated enum PostcardLibraryError: LocalizedError, Equatable {
    case invalidImage
    case alreadyExists
    case invalidRecord
    case unsupportedVersion(Int)

    var errorDescription: String? {
        switch self {
        case .invalidImage: "No se pudo leer una de las imágenes de la postal."
        case .alreadyExists: "Esta postal ya está guardada."
        case .invalidRecord: "No se pudieron recuperar los datos de la postal."
        case .unsupportedVersion: "Esta postal requiere una versión más reciente de la app."
        }
    }
}
