//
//  PaletteStudyViewModel.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import Foundation
import Combine

final class PaletteStudyViewModel: ObservableObject {
    @Published var selectedTab: PaletteStudyTab = .catalog
    @Published private(set) var content: PaletteStudyContent
    @Published private(set) var calculationResult: NawalCalculationResult?
    @Published private(set) var calculationErrorMessage: String?
    @Published private(set) var postcardDraft: NawalPostcardDraft?

    private var calculatedDraft: NawalPostcardDraft?

    private let useCase: PaletteStudyUseCase
    private let nawalCalculator: NawalCalculator

    init(
        useCase: PaletteStudyUseCase,
        nawalCalculator: NawalCalculator = NawalCalculator()
    ) {
        self.useCase = useCase
        self.nawalCalculator = nawalCalculator
        self.content = useCase.loadStudyContent()
    }

    var tabs: [PaletteStudyTab] {
        PaletteStudyTab.allCases
    }

    func selectTab(_ tab: PaletteStudyTab) {
        selectedTab = tab
    }

    func createPostcard() {
        guard let calculatedDraft else { return }
        postcardDraft = calculatedDraft
        selectedTab = .postcard
    }

    /// Calculates any date without replacing the user's current birth-date result or postcard draft.
    func calculateNawalResult(for date: Date) throws -> NawalCalculationResult {
        try nawalCalculator.calculate(for: date, nawales: content.catalogItems)
    }

    func calculateNawal(for date: Date) {
        do {
            let result = try calculateNawalResult(for: date)
            calculationResult = result
            calculationErrorMessage = nil
            calculatedDraft = NawalPostcardDraft(
                result: result,
                birthDateText: date.formatted(
                    .dateTime.day().month(.wide).year().locale(Locale(identifier: "es_MX"))
                )
            )
        } catch {
            calculationResult = nil
            calculatedDraft = nil
            calculationErrorMessage = error.localizedDescription
        }
    }
}
