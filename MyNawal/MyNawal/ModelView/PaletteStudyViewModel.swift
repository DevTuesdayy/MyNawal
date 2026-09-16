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

    func calculateNawal(for date: Date) {
        do {
            calculationResult = try nawalCalculator.calculate(
                for: date,
                nawales: content.catalogItems
            )
            calculationErrorMessage = nil
        } catch {
            calculationResult = nil
            calculationErrorMessage = error.localizedDescription
        }
    }
}
