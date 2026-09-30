//
//  PaletteStudyRepository.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import Foundation

protocol PaletteStudyRepository {
    func fetchContent() -> PaletteStudyContent
}

struct MockPaletteStudyRepository: PaletteStudyRepository {
    func fetchContent() -> PaletteStudyContent {
        PaletteStudyContent(
            catalogTitle: "Catálogo de Nawales",
            catalogSubtitle: "Explora los 20 símbolos sagrados",
            catalogItems: NawalCatalogo.items,
            selectedNawal: PaletteNawalDetail(
                title: "Tu Nawal es",
                subtitle: "Imox",
                description: "Simbolo de lo profundo, lo primordial y el inicio de todo. Representa el agua, la intuicion y la energia de la vida.",
                dateText: "18 de mayo de 2005",
                energyText: "Renacimiento • Intuicion • Fluidez",
                actionTitle: "Tomar mi selfie"
            ),
            birthDateText: "15 de mayo de 1990",
            postcardTitle: "Tu postal Nawal",
            postcardSubtitle: "Una propuesta para selfie y postal compartible con la misma paleta."
        )
    }
}
