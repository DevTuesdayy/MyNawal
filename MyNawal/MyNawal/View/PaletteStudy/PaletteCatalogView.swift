import SwiftUI

struct PaletteCatalogView: View {
    let content: PaletteStudyContent
    @State private var identificadorSeleccionado: UUID?
    @State private var nawalSeleccionado: PaletteNawalItem?
    @Namespace private var transicionNawal
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Environment(\.dynamicTypeSize) private var textSize

    private var columnas: [GridItem] {
        let cantidad = textSize.isAccessibilitySize ? 1 : (textSize >= .xxLarge ? 2 : 3)
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: cantidad)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text(content.catalogTitle)
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.mamFondo)
                        .accessibilityAddTraits(.isHeader)

                    Text(content.catalogSubtitle)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.75))

                    SeparadorHilos()
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .nawalEntrance()

                LazyVGrid(columns: columnas, spacing: 16) {
                    ForEach(Array(content.catalogItems.enumerated()), id: \.element.id) { index, nawal in
                        TarjetaCatalogoNawal(
                            nawal: nawal,
                            estaSeleccionado: identificadorSeleccionado == nawal.id
                        ) {
                            identificadorSeleccionado = nawal.id
                            nawalSeleccionado = nawal
                        }
                        .matchedTransitionSource(id: nawal.id, in: transicionNawal)
                        .nawalEntrance(delay: index < 6 ? Double(index) * 0.035 : 0)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .background(
            FondoEstuco()
                .ignoresSafeArea()
        )
        .onAppear {
            if identificadorSeleccionado == nil {
                identificadorSeleccionado = content.catalogItems.first(where: \.esDestacado)?.id
            }
        }
        .navigationDestination(item: $nawalSeleccionado) { nawal in
            if reduceMotion {
                DetalleNawalView(nawal: nawal)
                    .navigationTransition(.automatic)
            } else {
                DetalleNawalView(nawal: nawal)
                    .navigationTransition(.zoom(sourceID: nawal.id, in: transicionNawal))
            }
        }
    }
}

#Preview {
    PaletteCatalogView(content: MockPaletteStudyRepository().fetchContent())
}
