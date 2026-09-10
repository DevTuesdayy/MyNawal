//
//  PaletteStudyModels.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import Foundation

struct PaletteStudyContent: Hashable {
    let catalogTitle: String
    let catalogSubtitle: String
    let catalogItems: [PaletteNawalItem]
    let postcardTitle: String
    let postcardSubtitle: String
}

struct PaletteNawalItem: Identifiable, Hashable {
    let id = UUID()
    let nombre: String
    let esDestacado: Bool
    let nombreImagen: String
    let significado: String
    let descripcion: String
    let energia: String

    init(
        nombre: String,
        esDestacado: Bool,
        nombreImagen: String,
        significado: String = "Símbolo sagrado del Cholq’ij",
        descripcion: String = "Una energía sagrada que acompaña tu camino dentro del Cholq’ij.",
        energia: String = "Conexión • Equilibrio • Propósito"
    ) {
        self.nombre = nombre
        self.esDestacado = esDestacado
        self.nombreImagen = nombreImagen
        self.significado = significado
        self.descripcion = descripcion
        self.energia = energia
    }
}

enum PaletteStudyTab: CaseIterable, Identifiable {
    case catalog
    case calculator
    case postcard

    var id: Self { self }

    var title: String {
        switch self {
        case .catalog:
            "Catálogo"
        case .calculator:
            "Mi Nawal"
        case .postcard:
            "Postal"
        }
    }

    var systemImage: String {
        switch self {
        case .catalog:
            "square.grid.2x2.fill"
        case .calculator:
            "calendar"
        case .postcard:
            "camera.viewfinder"
        }
    }
}
