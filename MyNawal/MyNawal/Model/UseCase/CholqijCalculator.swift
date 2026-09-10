import Foundation

struct CholqijCalculation: Hashable {
    let julianDayNumber: Int
    let nawalIndex: Int
    let energyNumber: Int
}

struct CholqijCalculator {
    static let nativeNawalNames = [
        "Ajpu'", // Ajaw en la nomenclatura de la Cuenta Larga
        "Imox",
        "Iq'",
        "Aq'ab'al",
        "K'at",
        "Kan",
        "Kame",
        "Kej",
        "Q'anil",
        "Toj",
        "Tz'i",
        "B'atz'",
        "E",
        "Aj",
        "I'x",
        "Tz'ikin",
        "Ajmaq",
        "No'j",
        "Tijax",
        "Kawoq"
    ]

    private let gmtCorrelation = 584_283

    func calculate(for date: Date, userCalendar: Calendar = .current) -> CholqijCalculation? {
        let selectedComponents = userCalendar.dateComponents([.year, .month, .day], from: date)
        guard
            let year = selectedComponents.year,
            let month = selectedComponents.month,
            let day = selectedComponents.day
        else {
            return nil
        }

        let jdn = gregorianJulianDayNumber(year: year, month: month, day: day)
        let longCountDays = jdn - gmtCorrelation

        return CholqijCalculation(
            julianDayNumber: jdn,
            nawalIndex: positiveModulo(longCountDays, modulus: 20),
            energyNumber: positiveModulo(longCountDays + 3, modulus: 13) + 1
        )
    }

    private func gregorianJulianDayNumber(year: Int, month: Int, day: Int) -> Int {
        let adjustment = (14 - month) / 12
        let adjustedYear = year + 4_800 - adjustment
        let adjustedMonth = month + (12 * adjustment) - 3

        return day
            + ((153 * adjustedMonth + 2) / 5)
            + (365 * adjustedYear)
            + (adjustedYear / 4)
            - (adjustedYear / 100)
            + (adjustedYear / 400)
            - 32_045
    }

    private func positiveModulo(_ value: Int, modulus: Int) -> Int {
        let remainder = value % modulus
        return remainder >= 0 ? remainder : remainder + modulus
    }
}
