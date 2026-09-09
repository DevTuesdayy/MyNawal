//
//  PaletteStudyUseCase.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import Foundation

protocol PaletteStudyUseCase {
    func loadStudyContent() -> PaletteStudyContent
}

struct DefaultPaletteStudyUseCase: PaletteStudyUseCase {
    private let repository: PaletteStudyRepository

    init(repository: PaletteStudyRepository) {
        self.repository = repository
    }

    func loadStudyContent() -> PaletteStudyContent {
        repository.fetchContent()
    }
}
