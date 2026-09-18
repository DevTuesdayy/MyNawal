import SwiftUI

struct CalculadorView: View {
    let result: NawalCalculationResult?
    let errorMessage: String?
    let onCalculate: (Date) -> Void
    let onCreatePostcard: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectDate = Date()
    @State private var mostrarFecha = false
    @State private var hasCalculatedSelectedDate = false
    @State private var isCalculating = false
    @State private var revealResult = false
    @State private var calculationRequest = UUID()
    @ScaledMetric(relativeTo: .title3) private var tamanoControl = 20.0

    private var fechaTexto: String {
        selectDate.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "es_MX")))
    }

    var body: some View {
        GeometryReader { espacio in
            ScrollView {
                contenido
                    .frame(minHeight: max(0, espacio.size.height - 48))
                    .padding(.vertical, 24)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .background(FondoEstuco().ignoresSafeArea())
        .sheet(isPresented: $mostrarFecha) {
            NavigationStack {
                DatePicker("Fecha de nacimiento", selection: $selectDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "es_MX"))
                    .padding()
                    .navigationTitle("Fecha de nacimiento")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Listo") { mostrarFecha = false }
                        }
                    }
            }
            .tint(Color.mamJade)
            .presentationDetents([.medium, .large])
        }
        .onChange(of: selectDate) { _, _ in
            hasCalculatedSelectedDate = false
            isCalculating = false
            revealResult = false
            calculationRequest = UUID()
        }
        .task(id: calculationRequest) {
            guard isCalculating, hasCalculatedSelectedDate else { return }

            if !reduceMotion {
                do {
                    try await Task.sleep(for: .milliseconds(550))
                } catch {
                    return
                }
            }

            guard !Task.isCancelled else { return }
            withAnimation(reduceMotion ? nil : .spring(response: 0.48, dampingFraction: 0.8)) {
                isCalculating = false
                revealResult = true
            }
        }
    }

    private var contenido: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Calcula tu Nawal")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamFondo)
                    .accessibilityAddTraits(.isHeader)
                Text("Ingresa tu fecha de nacimiento")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.75))
                SeparadorHilos()
                    .padding(.top, 4)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 40)

            VStack(alignment: .leading, spacing: 12) {
                Text("Fecha de nacimiento")
                    .font(.system(.callout, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamFondo)

                Button { mostrarFecha = true } label: {
                    HStack {
                        Text(fechaTexto)
                            .font(.system(size: tamanoControl, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.mamFondo)
                        Spacer(minLength: 12)
                        Image(systemName: "calendar")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.mamJade)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, minHeight: 64)
                    .superficieEstuco()
                }
                .buttonStyle(NawalPressStyle())
                .accessibilityLabel("Fecha de nacimiento")
                .accessibilityValue(fechaTexto)
                .accessibilityHint("Abre el selector de fecha")
            }

            Spacer(minLength: 40)
                .frame(maxHeight: 160)

            Button {
                revealResult = false
                isCalculating = true
                hasCalculatedSelectedDate = true
                onCalculate(selectDate)
                calculationRequest = UUID()
            } label: {
                HStack(spacing: 10) {
                    if isCalculating {
                        ProgressView()
                            .tint(Color.mamBlanco)
                            .accessibilityHidden(true)
                    }
                    Text(isCalculating ? "Descubriendo tu Nawal…" : "Calcular mi Nawal")
                        .font(.system(size: tamanoControl, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(Color.mamBlanco)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.mamJade)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.mamArena, lineWidth: 1)
                }
                .shadow(color: Color.mamFondo.opacity(0.09), radius: 2, x: 0, y: 2)
            }
            .buttonStyle(NawalPressStyle())
            .disabled(isCalculating)
            .accessibilityLabel(isCalculating ? "Calculando tu Nawal" : "Calcular mi Nawal")

            if let result, hasCalculatedSelectedDate, revealResult {
                ResultadoNawalCalculado(result: result)
                    .padding(.top, 24)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.94).combined(with: .opacity),
                        removal: .opacity
                    ))

                Button(action: onCreatePostcard) {
                    Label("Crear mi postal", systemImage: "camera.on.rectangle")
                        .font(.system(.headline, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.mamBlanco)
                        .padding(18)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(Color.mamArena, lineWidth: 1)
                        }
                }
                .buttonStyle(NawalPressStyle())
                .accessibilityHint("Abre Postal con tu nawal, energía y fecha calculados")
                .padding(.top, 18)
                .transition(reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity))
            } else if let errorMessage, hasCalculatedSelectedDate, revealResult {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(Color.mamRojo)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                    .accessibilityLabel("Error: \(errorMessage)")
            }
        }
        .frame(maxWidth: 520)
        .nawalEntrance()
    }
}

private struct ResultadoNawalCalculado: View {
    let result: NawalCalculationResult

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var appeared = false

    private var datosLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 12))
    }

    var body: some View {
        VStack(spacing: 18) {
            Label("Tu resultado", systemImage: "sparkles")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamFondo)

            ZStack {
                Circle()
                    .stroke(Color.mamArena.opacity(0.65), lineWidth: 2)
                    .frame(width: 172, height: 172)
                    .scaleEffect(appeared ? 1.18 : 0.72)
                    .opacity(appeared ? 0 : 0.8)

                ImagenNawalLocal(nombre: result.nawal.nombreImagen)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .scaleEffect(appeared || reduceMotion ? 1 : 0.86)

                Text("\(result.energia)")
                    .font(.system(.title3, design: .rounded, weight: .black))
                    .foregroundStyle(Color.mamBlanco)
                    .frame(width: 46, height: 46)
                    .background(Color.mamJade)
                    .clipShape(Circle())
                    .overlay {
                        Circle().strokeBorder(Color.mamArena, lineWidth: 2)
                    }
                    .offset(x: 67, y: -67)
                    .scaleEffect(appeared || reduceMotion ? 1 : 0.6)
            }
            .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text("\(result.energia) \(result.nawal.nombre)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.mamJade)

                Text(result.nawal.informacion.significado)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(Color.mamFondo.opacity(0.78))
                    .multilineTextAlignment(.center)
            }

            datosLayout {
                DatoNawalCalculado(
                    icono: "pawprint.fill",
                    titulo: "Animal o representación",
                    valor: result.nawal.informacion.animal
                )
                DatoNawalCalculado(
                    icono: "leaf.fill",
                    titulo: "Elemento",
                    valor: result.nawal.informacion.elemento
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .superficieEstuco()
        .opacity(appeared || reduceMotion ? 1 : 0)
        .offset(y: appeared || reduceMotion ? 0 : 16)
        .onAppear {
            guard !appeared else { return }
            withAnimation(reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.76)) {
                appeared = true
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "Resultado: energía \(result.energia), nawal \(result.nawal.nombre). "
                + "Animal o representación: \(result.nawal.informacion.animal). "
                + "Elemento: \(result.nawal.informacion.elemento)"
        )
    }
}

private struct DatoNawalCalculado: View {
    let icono: String
    let titulo: String
    let valor: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icono)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.mamJade)

            Text(titulo)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.mamFondo.opacity(0.68))
                .multilineTextAlignment(.center)

            Text(valor)
                .font(.system(.body, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamFondo)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .top)
        .padding(14)
        .background(Color.mamJade.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    CalculadorView(result: nil, errorMessage: nil, onCalculate: { _ in }, onCreatePostcard: {})
}
