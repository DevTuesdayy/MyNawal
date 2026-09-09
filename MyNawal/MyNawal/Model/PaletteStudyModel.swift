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
    let selectedNawal: PaletteNawalDetail
    let birthDateText: String
    let postcardTitle: String
    let postcardSubtitle: String
}

struct PaletteNawalItem: Identifiable, Hashable {
    let id = UUID()
    let nombre: String
    let esDestacado: Bool
    let nombreImagen: String
}

struct PaletteNawalDetail: Hashable {
    let title: String
    let subtitle: String
    let description: String
    let dateText: String
    let energyText: String
    let actionTitle: String
}

enum PaletteStudyTab: CaseIterable, Identifiable {
    case catalog
    case detail
    case postcard

    var id: Self { self }

    var title: String {
        switch self {
        case .catalog:
            "Catalogo"
        case .detail:
            "Detalle"
        case .postcard:
            "Postal"
        }
    }

    var systemImage: String {
        switch self {
        case .catalog:
            "square.grid.2x2.fill"
        case .detail:
            "sparkles"
        case .postcard:
            "camera.viewfinder"
        }
    }
}
