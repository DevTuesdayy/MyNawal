import Foundation
import XCTest
@testable import MyNawal

@MainActor
final class NawalCalculatorTests: XCTestCase {
    private var calendar: Calendar!
    private var calculator: NawalCalculator!

    override func setUp() {
        super.setUp()
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        self.calendar = calendar
        calculator = NawalCalculator(calendar: calendar)
    }

    func testExpectedSequenceFromReferenceDate() throws {
        // Se conservan los nombres del catálogo: K'at, Kame y Kej ocupan
        // las posiciones Ky'ech, Ky'mex y Chej de la secuencia de referencia.
        let expected: [(year: Int, month: Int, day: Int, energy: Int, name: String)] = [
            (1954, 12, 10, 11, "K'at"),
            (1954, 12, 11, 12, "Kan"),
            (1954, 12, 12, 13, "Kame"),
            (1954, 12, 13, 1, "Kej"),
            (1954, 12, 14, 2, "Q'anil"),
        ]

        for value in expected {
            let result = try calculator.calculate(
                for: date(value.year, value.month, value.day),
                nawales: NawalCatalogo.items
            )

            XCTAssertEqual(result.energia, value.energy)
            XCTAssertEqual(result.nawal.nombre, value.name)
        }
    }

    func testDateBeforeReferenceUsesPositiveModulo() throws {
        let result = try calculator.calculate(
            for: date(1954, 12, 9),
            nawales: NawalCatalogo.items
        )

        XCTAssertEqual(result.energia, 10)
        XCTAssertEqual(result.nawal.nombre, "Aq'ab'al")
    }

    func testTimeOfDayDoesNotChangeResult() throws {
        let startOfDay = date(1954, 12, 10, hour: 0)
        let endOfDay = date(1954, 12, 10, hour: 23)

        let first = try calculator.calculate(for: startOfDay, nawales: NawalCatalogo.items)
        let second = try calculator.calculate(for: endOfDay, nawales: NawalCatalogo.items)

        XCTAssertEqual(first.nawal.nombre, second.nawal.nombre)
        XCTAssertEqual(first.energia, second.energia)
    }

    func testCompleteCycleRepeatsAfter260Days() throws {
        let base = date(1954, 12, 10)
        let repeatedDate = try XCTUnwrap(calendar.date(byAdding: .day, value: 260, to: base))

        let baseResult = try calculator.calculate(for: base, nawales: NawalCatalogo.items)
        let repeatedResult = try calculator.calculate(for: repeatedDate, nawales: NawalCatalogo.items)

        XCTAssertEqual(repeatedResult.nawal.nombre, baseResult.nawal.nombre)
        XCTAssertEqual(repeatedResult.energia, baseResult.energia)
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour
        ))!
    }
}
