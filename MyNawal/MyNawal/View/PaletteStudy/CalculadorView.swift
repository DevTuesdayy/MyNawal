//
//  CalculadorView.swift
//  MyNawal
//
//  Created by Alan Cervantes on 09/09/26.
//

import SwiftUI

struct CalculadorView: View {
    let content: PaletteStudyContent
    let onCalculation: (PaletteNawalItem, Int, Date) -> Void

    @State private var selectDate = Date()
    @State private var resultado: ResultadoNawal?

    private let calculator = CholqijCalculator()

    init(
        content: PaletteStudyContent,
        onCalculation: @escaping (PaletteNawalItem, Int, Date) -> Void = { _, _, _ in }
    ) {
        self.content = content
        self.onCalculation = onCalculation
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        ZStack {
            NawalBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.mamFondo, Color.mamJade],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Circle()
                            .stroke(Color.mamAmarillo.opacity(0.18), lineWidth: 1)
                            .frame(width: 190, height: 190)
                            .offset(x: 230, y: -75)

                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "moon.stars.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(Color.mamAmarillo)
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.09))
                                .clipShape(Circle())

                            Text("DESCUBRE TU ENERGÍA")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .tracking(1.6)
                                .foregroundStyle(Color.mamAmarillo)

                            Text("Calcula tu Nawal")
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundStyle(Color.mamCrema)

                            Text("Tu fecha de nacimiento conecta con una de las 20 energías del Cholq’ij.")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.mamCrema.opacity(0.72))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(24)
                    }
                    .frame(height: 270)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.mamFondo.opacity(0.18), radius: 18, y: 10)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FECHA DE NACIMIENTO")
                                    .font(.system(size: 11, weight: .black, design: .rounded))
                                    .tracking(1.2)
                                    .foregroundStyle(Color.mamJade)

                                Text(dateFormatter.string(from: selectDate))
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.mamFondo)
                            }

                            Spacer()

                            Image(systemName: "calendar.badge.checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color.mamOro)
                                .frame(width: 44, height: 44)
                                .background(Color.mamOro.opacity(0.11))
                                .clipShape(Circle())
                        }

                        Divider()
                            .overlay(Color.mamFondo.opacity(0.08))

                        DatePicker(
                            "Fecha de nacimiento",
                            selection: $selectDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .tint(Color.mamJade)
                        .environment(\.locale, Locale(identifier: "es_MX"))
                    }
                    .padding(20)
                    .background(Color.mamTarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .stroke(Color.mamFondo.opacity(0.06), lineWidth: 1)
                    }
                    .shadow(color: Color.mamFondo.opacity(0.08), radius: 12, y: 6)

                    Label("El calendario sagrado transforma esta fecha en tu energía nawal.", systemImage: "info.circle.fill")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.58))
                        .padding(.horizontal, 10)

                    Button(action: calcular) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                            Text("Descubrir mi Nawal")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamCrema)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            LinearGradient(
                                colors: [Color.mamJade, Color.mamFondo],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
                        .shadow(color: Color.mamFondo.opacity(0.2), radius: 12, y: 7)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 38)
            }
        }
        .navigationDestination(item: $resultado) { resultado in
            DetalleNawalView(
                nawal: resultado.nawal,
                numeroEnergia: resultado.numeroEnergia,
                fechaSeleccionada: resultado.fecha
            )
        }
    }

    private func calcular() {
        guard
            let calculo = calculator.calculate(for: selectDate),
            CholqijCalculator.nativeNawalNames.indices.contains(calculo.nawalIndex)
        else {
            return
        }

        let nombreNawal = CholqijCalculator.nativeNawalNames[calculo.nawalIndex]

        guard let nawal = content.catalogItems.first(where: { $0.nombre == nombreNawal }) else {
            return
        }

        resultado = ResultadoNawal(
            nawal: nawal,
            numeroEnergia: calculo.energyNumber,
            fecha: selectDate
        )
        onCalculation(nawal, calculo.energyNumber, selectDate)
    }
}

private struct ResultadoNawal: Identifiable, Hashable {
    let id = UUID()
    let nawal: PaletteNawalItem
    let numeroEnergia: Int
    let fecha: Date
}

#Preview {
    NavigationStack {
        CalculadorView(content: MockPaletteStudyRepository().fetchContent())
    }
}
