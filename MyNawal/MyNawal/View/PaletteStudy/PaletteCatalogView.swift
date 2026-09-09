import SwiftUI

struct PaletteCatalogView: View {
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

#Preview {
    PaletteCatalogView(content: MockPaletteStudyRepository().fetchContent())
}
