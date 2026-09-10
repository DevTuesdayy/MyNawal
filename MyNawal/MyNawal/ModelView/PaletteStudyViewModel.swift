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
    @Published private(set) var calculatedNawal: PaletteNawalItem?
    @Published private(set) var calculatedEnergyNumber: Int?
    @Published private(set) var calculatedBirthDate: Date?

    private let useCase: PaletteStudyUseCase

    init(useCase: PaletteStudyUseCase) {
        self.useCase = useCase
        let loadedContent = useCase.loadStudyContent()
        self.content = loadedContent
        self.calculatedNawal = nil
    }

    var tabs: [PaletteStudyTab] {
        PaletteStudyTab.allCases
    }

    func selectTab(_ tab: PaletteStudyTab) {
        selectedTab = tab
    }

    func updateCalculation(nawal: PaletteNawalItem, energyNumber: Int, birthDate: Date) {
        calculatedNawal = nawal
        calculatedEnergyNumber = energyNumber
        calculatedBirthDate = birthDate
    }
}
