import Foundation

nonisolated struct NawalPostcardDraft: Codable, Hashable, Sendable {
    let result: NawalCalculationResult
    let birthDateText: String
}
