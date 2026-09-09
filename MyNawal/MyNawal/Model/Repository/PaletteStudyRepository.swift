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
            catalogTitle: "Catalogo de Nawales",
            catalogSubtitle: "Explora los 20 simbolos sagrados",
            catalogItems: [
                PaletteNawalItem(name: "Imox", isFeatured: true, symbol: "imox"),
                PaletteNawalItem(name: "Ik'", isFeatured: false, symbol: "ik"),
                PaletteNawalItem(name: "Ak'bal", isFeatured: false, symbol: "akbal"),
                PaletteNawalItem(name: "K'at", isFeatured: false, symbol: "kat"),
                PaletteNawalItem(name: "Kan", isFeatured: false, symbol: "kan"),
                PaletteNawalItem(name: "Kame", isFeatured: false, symbol: "kame"),
                PaletteNawalItem(name: "Kej", isFeatured: false, symbol: "kej"),
                PaletteNawalItem(name: "Q'anil", isFeatured: false, symbol: "qanil"),
                PaletteNawalItem(name: "Toj", isFeatured: false, symbol: "toj")
            ],
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
