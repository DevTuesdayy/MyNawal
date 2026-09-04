//
//  PaletteStudyView.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import SwiftUI
import UIKit

struct PaletteStudyView: View {
    @ObservedObject var viewModel: PaletteStudyViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            PaletteCatalogView(content: viewModel.content)
                .tag(PaletteStudyTab.catalog)
                .tabItem {
                    Label(PaletteStudyTab.catalog.title, systemImage: PaletteStudyTab.catalog.systemImage)
                }
            
            PaletteDetailView(content: viewModel.content)
                .tag(PaletteStudyTab.detail)
                .tabItem {
                    Label(PaletteStudyTab.detail.title, systemImage: PaletteStudyTab.detail.systemImage)
                }
            
            PalettePostcardView(content: viewModel.content)
                .tag(PaletteStudyTab.postcard)
                .tabItem {
                    Label(PaletteStudyTab.postcard.title, systemImage: PaletteStudyTab.postcard.systemImage)
                }
        }
        .tint(Color.mamAmarillo)
        .toolbarBackground(Color.mamFondo, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
    }
}

private struct PaletteCatalogView: View {
    let content: PaletteStudyContent
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.catalogTitle)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                    
                    Text(content.catalogSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                }
                
                HStack(spacing: 10) {
                    PaletteCatalogBadge(title: "Base clara", background: .mamBlanco, foreground: .mamFondo)
                    PaletteCatalogBadge(title: "Activo", background: .mamJade, foreground: .mamBlanco)
                    PaletteCatalogBadge(title: "Acento", background: .mamAmarillo, foreground: .mamFondo)
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(content.catalogItems) { item in
                        PaletteCatalogTile(item: item)
                    }
                }
            }
            .padding(20)
        }
        .background(
            LinearGradient(
                colors: [Color.mamBlanco, Color.mamBlanco, Color.mamArena.opacity(0.18)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

private struct PaletteDetailView: View {
    let content: PaletteStudyContent
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.mamFondo, Color(red: 2 / 255, green: 32 / 255, blue: 29 / 255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Spacer()
                        Text("Tu Nawal")
                            .font(.headline.bold())
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .opacity(0)
                    }
                    .foregroundStyle(Color.mamBlanco)
                    
                    OrnamentLine()
                    
                    VStack(spacing: 6) {
                        Text(content.selectedNawal.title)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.mamBlanco)
                        
                        Text(content.selectedNawal.subtitle)
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(Color.mamAmarillo)
                        
                        Text("(Cocodrilo / Agua)")
                            .font(.headline)
                            .foregroundStyle(Color.mamBlanco.opacity(0.86))
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .fill(Color.mamJade.opacity(0.12))
                            .frame(width: 236, height: 236)
                        
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.mamArena)
                            .frame(width: 192, height: 192)
                            .overlay {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.mamAmarillo.opacity(0.55), lineWidth: 2)
                                    .padding(2)
                            }
                        
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.mamBlanco)
                            .frame(width: 168, height: 168)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(Color.mamJade, lineWidth: 5)
                            }
                        
                        LocalNawalImage(name: "Imox")
                            .padding(16)
                            .frame(width: 164, height: 164)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    
                    HStack(spacing: 12) {
                        ForEach(0..<5, id: \.self) { _ in
                            Circle()
                                .fill(Color.mamRojo)
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text(content.selectedNawal.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.mamBlanco.opacity(0.84))
                        .padding(.horizontal, 12)
                        .frame(maxWidth: 340)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Fecha correspondiente")
                                .font(.caption.bold())
                                .foregroundStyle(Color.mamAmarillo)
                            Spacer()
                            SmallOrnament()
                        }
                        
                        Text(content.selectedNawal.dateText)
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color.mamBlanco)
                        
                        Divider()
                            .overlay(Color.mamArena.opacity(0.35))
                        
                        Text("Energia")
                            .font(.caption.bold())
                            .foregroundStyle(Color.mamAmarillo)
                        
                        Text(content.selectedNawal.energyText)
                            .font(.body)
                            .foregroundStyle(Color.mamBlanco.opacity(0.92))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.black.opacity(0.18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.mamArena.opacity(0.55), lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    
                    Button(action: {}) {
                        Label(content.selectedNawal.actionTitle, systemImage: "camera")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(Color.mamBlanco)
                            .background(Color.mamJade)
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.mamArena.opacity(0.4), lineWidth: 1.5)
                                    .padding(1)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }
        }
    }
}

private struct PalettePostcardView: View {
    let content: PaletteStudyContent
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.postcardTitle)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                    
                    Text(content.postcardSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                }
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.mamBlanco, Color.mamBlanco, Color.mamArena.opacity(0.34)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 480)
                    .overlay {
                        VStack(spacing: 14) {
                            Text("Mi Nawal es")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Color.mamFondo)
                            
                            Text(content.selectedNawal.subtitle)
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundStyle(Color.mamFondo)
                            
                            Text("(Cocodrilo / Agua)")
                                .font(.subheadline)
                                .foregroundStyle(Color.mamFondo.opacity(0.82))
                            
                            LocalNawalImage(name: "Imox")
                                .padding(10)
                                .frame(width: 146, height: 146)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(Color.mamJade.opacity(0.5), lineWidth: 2)
                                }
                                .shadow(color: Color.mamFondo.opacity(0.1), radius: 10, y: 4)
                            
                            VStack(spacing: 6) {
                                Text(content.birthDateText)
                                    .font(.headline)
                                    .foregroundStyle(Color.mamFondo)
                                Text(content.selectedNawal.energyText)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.mamFondo.opacity(0.8))
                            }
                            
                            HStack(spacing: 10) {
                                PaletteDot(color: .mamJade)
                                PaletteDot(color: .mamRojo)
                                PaletteDot(color: .mamAmarillo)
                                PaletteDot(color: .mamMorado)
                                PaletteDot(color: .mamAzul)
                            }
                        }
                        .padding(24)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color.mamJade, lineWidth: 3)
                    )
                
                HStack(spacing: 12) {
                    PalettePostcardAction(title: "Guardar", icon: "arrow.down", background: .mamJade)
                    PalettePostcardAction(title: "Compartir", icon: "square.and.arrow.up", background: .mamFondo)
                }
                
                HStack(spacing: 12) {
                    PaletteSampleStrip(color: .mamArena, title: "Superficie", darkText: true)
                    PaletteSampleStrip(color: .mamRojo, title: "Sello de energia")
                    PaletteSampleStrip(color: .mamAmarillo, title: "Acento", darkText: true)
                }
            }
            .padding(20)
        }
        .background(Color.mamBlanco.ignoresSafeArea())
    }
}

private struct PaletteCatalogTile: View {
    let item: PaletteNawalItem
    
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(item.isFeatured ? Color.mamJade.opacity(0.16) : Color.white.opacity(0.92))
                .frame(height: 88)
                .overlay {
                    LocalNawalImage(name: item.symbol)
                        .padding(10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(item.isFeatured ? Color.mamJade.opacity(0.85) : Color.mamArena.opacity(0.9), lineWidth: 2)
                        .padding(12)
                }
                .overlay(alignment: .topTrailing) {
                    if item.isFeatured {
                        Circle()
                            .fill(Color.mamAmarillo)
                            .frame(width: 10, height: 10)
                            .padding(10)
                    }
                }
            
            Text(item.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.mamFondo)
        }
        .padding(12)
        .background(item.isFeatured ? Color.mamBlanco : Color.white.opacity(0.82))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(item.isFeatured ? Color.mamJade.opacity(0.45) : Color.mamArena.opacity(0.75), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PaletteCatalogBadge: View {
    let title: String
    let background: Color
    let foreground: Color
    
    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(background)
            .clipShape(Capsule())
    }
}

private struct PaletteDot: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 16, height: 16)
    }
}

private struct PalettePostcardAction: View {
    let title: String
    let icon: String
    let background: Color
    
    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline.weight(.semibold))
            .foregroundStyle(Color.mamBlanco)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct PaletteSampleStrip: View {
    let color: Color
    let title: String
    var darkText: Bool = false
    
    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(darkText ? Color.mamFondo : Color.mamBlanco)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct OrnamentLine: View {
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.mamJade)
                .frame(height: 2)
            SmallOrnament()
            Rectangle()
                .fill(Color.mamJade)
                .frame(height: 2)
        }
        .frame(maxWidth: 220)
    }
}

private struct SmallOrnament: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.mamJade)
                .frame(width: 6, height: 6)
            Rectangle()
                .fill(Color.mamJade)
                .frame(width: 16, height: 2)
            Circle()
                .fill(Color.mamAmarillo)
                .frame(width: 6, height: 6)
            Rectangle()
                .fill(Color.mamJade)
                .frame(width: 16, height: 2)
            Circle()
                .fill(Color.mamJade)
                .frame(width: 6, height: 6)
        }
    }
}

private struct LocalNawalImage: View {
    let name: String
    
    var body: some View {
        Group {
            if let uiImage = loadImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.mamArena.opacity(0.35))
                    .overlay {
                        Text(name)
                            .font(.caption.bold())
                            .foregroundStyle(Color.mamFondo)
                    }
            }
        }
    }
    
    private func loadImage(named name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            return image
        }
        
        if let image = UIImage(named: name.lowercased()) {
            return image
        }
        
        return nil
    }
}

#Preview {
    PaletteStudyView(
        viewModel: PaletteStudyViewModel(
            useCase: DefaultPaletteStudyUseCase(
                repository: MockPaletteStudyRepository()
            )
        )
    )
}
