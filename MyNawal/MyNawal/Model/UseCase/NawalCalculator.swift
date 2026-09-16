import Foundation

struct NawalCalculationResult: Hashable {
    let nawal: PaletteNawalItem
    let energia: Int
}

enum NawalCalculatorError: Error, Equatable, LocalizedError {
    case invalidNawalCount(expected: Int, actual: Int)
    case referenceNawalNotFound
    case invalidDate

    var errorDescription: String? {
        switch self {
        case let .invalidNawalCount(expected, actual):
            "Se esperaban \(expected) nawales, pero se encontraron \(actual)."
        case .referenceNawalNotFound:
            "No se encontró el nawal de referencia en el catálogo."
        case .invalidDate:
            "No fue posible normalizar la fecha seleccionada."
        }
    }
}

struct NawalCalculator {
    private static let cycleLength = 20
    private static let energyCycleLength = 13
    private static let baseEnergyZeroBased = 10

    // Ky'ech es el nombre de la referencia proporcionada para el cálculo.
    // El catálogo actual conserva K'at como nombre almacenado en esa posición.
    private static let referenceNames = ["Ky'ech", "K'at"]

    private let inputCalendar: Calendar
    private let calculationCalendar: Calendar

    init(calendar: Calendar = .autoupdatingCurrent) {
        inputCalendar = calendar

        var stableCalendar = Calendar(identifier: .gregorian)
        stableCalendar.locale = Locale(identifier: "en_US_POSIX")
        stableCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calculationCalendar = stableCalendar
    }

    func calculate(for selectedDate: Date, nawales: [PaletteNawalItem]) throws -> NawalCalculationResult {
        guard nawales.count == Self.cycleLength else {
            throw NawalCalculatorError.invalidNawalCount(
                expected: Self.cycleLength,
                actual: nawales.count
            )
        }

        guard let referenceIndex = nawales.firstIndex(where: isReferenceNawal) else {
            throw NawalCalculatorError.referenceNawalNotFound
        }

        let normalizedSelectedDate = try normalizedDate(selectedDate)
        guard let baseDate = calculationCalendar.date(
            from: DateComponents(year: 1954, month: 12, day: 10)
        ),
        let dayDifference = calculationCalendar.dateComponents(
            [.day],
            from: baseDate,
            to: normalizedSelectedDate
        ).day else {
            throw NawalCalculatorError.invalidDate
        }

        let nawalIndex = positiveModulo(referenceIndex + dayDifference, Self.cycleLength)
        let energy = positiveModulo(
            Self.baseEnergyZeroBased + dayDifference,
            Self.energyCycleLength
        ) + 1

        return NawalCalculationResult(nawal: nawales[nawalIndex], energia: energy)
    }

    private func normalizedDate(_ date: Date) throws -> Date {
        let components = inputCalendar.dateComponents([.year, .month, .day], from: date)
        guard let normalizedDate = calculationCalendar.date(from: components) else {
            throw NawalCalculatorError.invalidDate
        }
        return normalizedDate
    }

    private func isReferenceNawal(_ nawal: PaletteNawalItem) -> Bool {
        let storedName = canonicalName(nawal.nombre)
        return Self.referenceNames.contains { canonicalName($0) == storedName }
    }

    private func canonicalName(_ value: String) -> String {
        value
            .replacingOccurrences(of: "’", with: "'")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    private func positiveModulo(_ value: Int, _ modulo: Int) -> Int {
        ((value % modulo) + modulo) % modulo
    }
}
