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

    private let useCase: PaletteStudyUseCase

    init(useCase: PaletteStudyUseCase) {
        self.useCase = useCase
        self.content = useCase.loadStudyContent()
    }

    var tabs: [PaletteStudyTab] {
        PaletteStudyTab.allCases
    }

    func selectTab(_ tab: PaletteStudyTab) {
        selectedTab = tab
    }
}
