import SwiftUI

struct CalculoNawalExplicacionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var mostrarFormula = false
    @State private var pasoActual = 0
    @State private var reproduciendo = false
    @State private var solicitudAnimacion = UUID()

    static let ejemplo: [(year: Int, month: Int, day: Int, fecha: String, energia: Int, nawal: String)] = [
        (1954, 12, 10, "10 dic 1954", 11, "K'at"),
        (1954, 12, 11, "11 dic 1954", 12, "Kan"),
        (1954, 12, 12, "12 dic 1954", 13, "Kame"),
        (1954, 12, 13, "13 dic 1954", 1, "Kej"),
        (1954, 12, 14, "14 dic 1954", 2, "Q'anil")
    ]

    private var ejemplo: [(year: Int, month: Int, day: Int, fecha: String, energia: Int, nawal: String)] {
        Self.ejemplo
    }

    private var distribucionFormula: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 8))
            : AnyLayout(HStackLayout(spacing: 8))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    encabezado
                        .nawalEntrance(delay: 0.04)
                    ciclos
                        .nawalEntrance(delay: 0.1)
                    secuencia
                        .nawalEntrance(delay: 0.18)
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .background(FondoEstuco().ignoresSafeArea())
            .navigationTitle("Cómo se calcula")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
        .tint(Color.mamJade)
        .presentationDetents([.large])
        .onAppear {
            guard !mostrarFormula else { return }
            mostrarFormula = true
        }
        .task(id: solicitudAnimacion) {
            guard reproduciendo else { return }

            for siguientePaso in 1..<ejemplo.count {
                do {
                    try await Task.sleep(for: .milliseconds(650))
                } catch {
                    return
                }

                guard !Task.isCancelled else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    pasoActual = siguientePaso
                }
            }

            reproduciendo = false
        }
        .onDisappear {
            reproduciendo = false
        }
    }

    private var encabezado: some View {
        VStack(spacing: 12) {
            Text("¿Cómo se calcula mi nawal?")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamFondo)
                .accessibilityAddTraits(.isHeader)

            Text("Cada día combina un nawal con un número de energía.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color.mamFondo.opacity(0.78))

            SeparadorHilos()
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }

    private var ciclos: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dos ciclos, un mismo día")
                .font(.system(.headline, design: .rounded))
                .accessibilityAddTraits(.isHeader)

            Text("Los 20 nawales y los números del 1 al 13 avanzan juntos, uno por día. Al terminar cada secuencia, esta vuelve a empezar. La misma combinación se repite después de 260 días.")
                .font(.system(.body, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                distribucionFormula {
                    etiquetaCiclo("20", titulo: "nawales")
                        .offset(x: mostrarFormula || reduceMotion ? 0 : -28)
                        .opacity(mostrarFormula || reduceMotion ? 1 : 0)
                        .animation(
                            reduceMotion ? nil : .spring(response: 0.55, dampingFraction: 0.8).delay(0.2),
                            value: mostrarFormula
                        )

                    Text("×")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.mamRojo)
                        .opacity(mostrarFormula || reduceMotion ? 1 : 0)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.25).delay(0.35), value: mostrarFormula)

                    etiquetaCiclo("13", titulo: "energías")
                        .offset(x: mostrarFormula || reduceMotion ? 0 : 28)
                        .opacity(mostrarFormula || reduceMotion ? 1 : 0)
                        .animation(
                            reduceMotion ? nil : .spring(response: 0.55, dampingFraction: 0.8).delay(0.2),
                            value: mostrarFormula
                        )
                }

                Text("260 días")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamJade)
                    .scaleEffect(mostrarFormula || reduceMotion ? 1 : 0.9)
                    .opacity(mostrarFormula || reduceMotion ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.78).delay(0.5),
                        value: mostrarFormula
                    )
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("20 nawales por 13 energías forman un ciclo de 260 días")
        }
        .foregroundStyle(Color.mamFondo)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .superficieEstuco()
    }

    private func etiquetaCiclo(_ cantidad: String, titulo: String) -> some View {
        VStack(spacing: 2) {
            Text(cantidad)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamJade)
            Text(titulo)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Color.mamFondo)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.mamArena.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }

    private var secuencia: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mira cómo avanzan")
                .font(.system(.headline, design: .rounded))
                .accessibilityAddTraits(.isHeader)

            HStack(alignment: .firstTextBaseline) {
                Text(ejemplo[pasoActual].fecha)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                Spacer()
                Text("Día \(pasoActual + 1) de \(ejemplo.count)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.7))
            }

            filaCiclo("Nawal", valor: ejemplo[pasoActual].nawal)
            filaCiclo("Energía", valor: "\(ejemplo[pasoActual].energia)")

            Button {
                if reduceMotion {
                    pasoActual = (pasoActual + 1) % ejemplo.count
                } else {
                    pasoActual = 0
                    reproduciendo = true
                    solicitudAnimacion = UUID()
                }
            } label: {
                Label(
                    reduceMotion
                        ? (pasoActual == ejemplo.count - 1 ? "Volver al inicio" : "Siguiente día")
                        : (pasoActual == ejemplo.count - 1 ? "Repetir ejemplo" : "Ver cómo avanza"),
                    systemImage: reduceMotion ? "arrow.right" : "play.fill"
                )
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.bordered)
            .disabled(reproduciendo)
            .accessibilityHint("Muestra cómo avanzan juntos el nawal y la energía cada día")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .superficieEstuco()
    }

    private func filaCiclo(_ titulo: String, valor: String) -> some View {
        HStack(spacing: 12) {
            Text(titulo)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Color.mamFondo)

            Spacer(minLength: 8)

            ZStack(alignment: .trailing) {
                Text(valor)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamJade)
                    .id(pasoActual)
                    .transition(reduceMotion ? .identity : .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .clipped()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(minHeight: 54)
        .background(Color.mamArena.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }

}

#Preview {
    CalculoNawalExplicacionView()
}
