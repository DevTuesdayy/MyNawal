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
                PaletteNawalItem(nombre: "Imox", esDestacado: true, nombreImagen: "nawal_01"),
                PaletteNawalItem(nombre: "Ik'", esDestacado: false, nombreImagen: "nawal_02"),
                PaletteNawalItem(nombre: "Ak'bal", esDestacado: false, nombreImagen: "nawal_03"),
                PaletteNawalItem(nombre: "K'an", esDestacado: false, nombreImagen: "nawal_04"),
                PaletteNawalItem(nombre: "Chikchan", esDestacado: false, nombreImagen: "nawal_05"),
                PaletteNawalItem(nombre: "Kimi", esDestacado: false, nombreImagen: "nawal_06"),
                PaletteNawalItem(nombre: "Manik'", esDestacado: false, nombreImagen: "nawal_07"),
                PaletteNawalItem(nombre: "Lamat", esDestacado: false, nombreImagen: "nawal_08"),
                PaletteNawalItem(nombre: "Muluk", esDestacado: false, nombreImagen: "nawal_09"),
                PaletteNawalItem(nombre: "Ok", esDestacado: false, nombreImagen: "nawal_10"),
                PaletteNawalItem(nombre: "Chuwen", esDestacado: false, nombreImagen: "nawal_11"),
                PaletteNawalItem(nombre: "Eb'", esDestacado: false, nombreImagen: "nawal_12"),
                PaletteNawalItem(nombre: "B'en", esDestacado: false, nombreImagen: "nawal_13"),
                PaletteNawalItem(nombre: "Ix", esDestacado: false, nombreImagen: "nawal_14"),
                PaletteNawalItem(nombre: "Men", esDestacado: false, nombreImagen: "nawal_15"),
                PaletteNawalItem(nombre: "K'ib'", esDestacado: false, nombreImagen: "nawal_16"),
                PaletteNawalItem(nombre: "Kab'an", esDestacado: false, nombreImagen: "nawal_17"),
                PaletteNawalItem(nombre: "Etz'nab'", esDestacado: false, nombreImagen: "nawal_18"),
                PaletteNawalItem(nombre: "Kawak", esDestacado: false, nombreImagen: "nawal_19"),
                PaletteNawalItem(nombre: "Ajaw", esDestacado: false, nombreImagen: "nawal_20")
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
