import SwiftUI

struct PaletteCatalogView: View {
    let content: PaletteStudyContent
    @State private var nawalSeleccionado: PaletteNawalItem?

    private let columnas = [
        GridItem(.adaptive(minimum: 100, maximum: 160), spacing: 12)
    ]

    var body: some View {
        ZStack {
            NawalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    encabezado

                    HStack(spacing: 8) {
                        Image(systemName: "hand.tap.fill")
                            .foregroundStyle(Color.mamOro)

                        Text("Toca un símbolo para conocer su energía")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.mamFondo.opacity(0.68))
                    }

                    LazyVGrid(columns: columnas, spacing: 14) {
                        ForEach(content.catalogItems) { nawal in
                            TarjetaCatalogoNawal(
                                nawal: nawal
                            ) {
                                nawalSeleccionado = nawal
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 36)
            }
        }
        .navigationDestination(item: $nawalSeleccionado) { nawal in
            DetalleNawalView(nawal: nawal)
        }
    }

    private var encabezado: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CHOLQ’IJ  ·  20 ENERGÍAS")
                .font(.system(size: 12, weight: .black, design: .rounded))
                .tracking(1.4)
                .foregroundStyle(Color.mamJade)

            Text(content.catalogTitle)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(Color.mamFondo)
                .fixedSize(horizontal: false, vertical: true)

            Text(content.catalogSubtitle)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(Color.mamFondo.opacity(0.65))

            OrnamentLine()
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PaletteCatalogView(content: MockPaletteStudyRepository().fetchContent())
}
