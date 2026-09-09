import SwiftUI

struct PaletteCatalogView: View {
    let content: PaletteStudyContent
    @State private var identificadorSeleccionado: UUID?
    @State private var nawalSeleccionado: PaletteNawalItem?

    private let columnas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text(content.catalogTitle)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(content.catalogSubtitle)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                }

                LazyVGrid(columns: columnas, spacing: 16) {
                    ForEach(content.catalogItems) { nawal in
                        TarjetaCatalogoNawal(
                            nawal: nawal,
                            estaSeleccionado: identificadorSeleccionado == nawal.id
                        ) {
                            identificadorSeleccionado = nawal.id
                            nawalSeleccionado = nawal
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
        .background(
            LinearGradient(
                colors: [Color.mamBlanco, Color.mamBlanco.opacity(0.94)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .onAppear {
            identificadorSeleccionado = content.catalogItems.first(where: \.esDestacado)?.id
        }
        .navigationDestination(item: $nawalSeleccionado) { nawal in
            DetalleNawalView(nawal: nawal, contenido: content)
        }
    }
}

#Preview {
    PaletteCatalogView(content: MockPaletteStudyRepository().fetchContent())
}
