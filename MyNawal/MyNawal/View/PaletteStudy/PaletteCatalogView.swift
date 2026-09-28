import SwiftUI

struct PaletteCatalogView: View {
    let content: PaletteStudyContent
    let calculateNawalResult: (Date) throws -> NawalCalculationResult
    @State private var identificadorSeleccionado: UUID?
    @State private var nawalSeleccionado: PaletteNawalItem?
    @State private var fechaNawalDelDia: Date?
    @State private var nawalDelDia: NawalCalculationResult?
    @State private var errorNawalDelDia: String?
    @State private var transitionSourceID: UUID?
    @State private var muestraDetalleDelDia = false
    @Namespace private var transicionNawal
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
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

                nawalDelDiaCard

                LazyVGrid(columns: columnas, spacing: 16) {
                    ForEach(Array(content.catalogItems.enumerated()), id: \.element.id) { index, nawal in
                        TarjetaCatalogoNawal(
                            nawal: nawal,
                            estaSeleccionado: identificadorSeleccionado == nawal.id
                        ) {
                            identificadorSeleccionado = nawal.id
                            transitionSourceID = nawal.id
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
        .task {
            if fechaNawalDelDia == nil {
                actualizarNawalDelDia()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                actualizarNawalDelDia()
            }
        }
        .navigationDestination(item: $nawalSeleccionado) { nawal in
            if reduceMotion || transitionSourceID != nawal.id {
                DetalleNawalView(nawal: nawal)
                    .navigationTransition(.automatic)
            } else {
                DetalleNawalView(nawal: nawal)
                    .navigationTransition(.zoom(sourceID: nawal.id, in: transicionNawal))
            }
        }
    }

    @ViewBuilder
    private var nawalDelDiaCard: some View {
        if let nawalDelDia, let fechaNawalDelDia {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.18)) {
                        muestraDetalleDelDia.toggle()
                    }
                } label: {
                    HStack(spacing: 12) {
                        ImagenNawalLocal(nombre: nawalDelDia.nawal.nombreImagen)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 46, height: 46)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("Nawal de hoy")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color.mamFondo)
                                Spacer(minLength: 0)
                                Text(fechaBreve(fechaNawalDelDia))
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Color.mamFondo.opacity(0.7))
                            }
                            Text("\(nawalDelDia.energia) \(nawalDelDia.nawal.nombre)")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .foregroundStyle(Color.mamJade)
                        }
                        .multilineTextAlignment(.leading)

                        Image(systemName: muestraDetalleDelDia ? "chevron.up" : "chevron.down")
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(Color.mamJade)
                            .accessibilityHidden(true)
                    }
                    .contentShape(Rectangle())
                    .frame(minHeight: 48)
                }
                .buttonStyle(NawalPressStyle())
                .accessibilityLabel("Nawal de hoy, energía \(nawalDelDia.energia), \(nawalDelDia.nawal.nombre)")
                .accessibilityValue(muestraDetalleDelDia ? "Información visible" : "Información oculta")
                .accessibilityHint(muestraDetalleDelDia ? "Oculta los datos del nawal" : "Muestra más información del nawal")

                if muestraDetalleDelDia {
                    Divider().overlay(Color.mamArena.opacity(0.5))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Animal o representación: \(nawalDelDia.nawal.informacion.animal)")
                        Text("Elemento: \(nawalDelDia.nawal.informacion.elemento)")
                        Text(nawalDelDia.nawal.informacion.significado)
                            .foregroundStyle(Color.mamFondo.opacity(0.76))

                        Button {
                            identificadorSeleccionado = nawalDelDia.nawal.id
                            transitionSourceID = nil
                            nawalSeleccionado = nawalDelDia.nawal
                        } label: {
                            Label("Ver ficha completa", systemImage: "arrow.right")
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.mamJade)
                        .padding(.top, 4)
                    }
                    .font(.system(.subheadline, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(reduceMotion ? .opacity : .move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .superficieEstuco()
        } else if let errorNawalDelDia {
            VStack(alignment: .leading, spacing: 10) {
                Label("No se pudo calcular el nawal de hoy", systemImage: "exclamationmark.triangle")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                Text(errorNawalDelDia)
                    .font(.footnote)
                Button("Intentar de nuevo", action: actualizarNawalDelDia)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
            }
            .foregroundStyle(Color.mamFondo)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .superficieEstuco()
        } else {
            ProgressView("Calculando el nawal de hoy…")
                .frame(maxWidth: .infinity, minHeight: 108)
                .superficieEstuco()
        }
    }

    private func actualizarNawalDelDia() {
        let now = Date()
        if let fechaNawalDelDia,
           !Calendar.current.isDate(fechaNawalDelDia, inSameDayAs: now) {
            muestraDetalleDelDia = false
        }
        do {
            nawalDelDia = try calculateNawalResult(now)
            fechaNawalDelDia = now
            errorNawalDelDia = nil
        } catch {
            nawalDelDia = nil
            fechaNawalDelDia = nil
            errorNawalDelDia = error.localizedDescription
        }
    }

    private func fechaBreve(_ date: Date) -> String {
        date.formatted(
            .dateTime.day().month(.abbreviated).year().locale(Locale(identifier: "es_GT"))
        )
    }
}

#Preview {
    PaletteCatalogView(
        content: MockPaletteStudyRepository().fetchContent(),
        calculateNawalResult: { date in
            try NawalCalculator().calculate(for: date, nawales: NawalCatalogo.items)
        }
    )
}
