import SwiftUI

struct DetalleNawalView: View {
    let nawal: PaletteNawalItem
    let numeroEnergia: Int?
    let fechaSeleccionada: Date?

    @Environment(\.dismiss) private var cerrarVista

    init(
        nawal: PaletteNawalItem,
        numeroEnergia: Int? = nil,
        fechaSeleccionada: Date? = nil
    ) {
        self.nawal = nawal
        self.numeroEnergia = numeroEnergia
        self.fechaSeleccionada = fechaSeleccionada
    }

    private var subtitulo: String {
        nawal.significado
    }

    private var descripcion: String {
        nawal.descripcion
    }

    private var energia: String {
        nawal.energia
    }

    private var fechaTexto: String? {
        guard let fechaSeleccionada else { return nil }
        return fechaSeleccionada.formatted(
            Date.FormatStyle(date: .long, time: .omitted, locale: Locale(identifier: "es_MX"))
        )
    }

    private var tituloEnergia: String {
        guard let numeroEnergia else { return "Energía" }
        return "Energía \(numeroEnergia)"
    }

    var body: some View {
        ZStack {
            NawalBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    encabezado
                    piezaPrincipal

                    VStack(alignment: .leading, spacing: 12) {
                        Label("El mensaje de \(nawal.nombre)", systemImage: "sparkles")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.mamJade)

                        Text(descripcion)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.mamFondo.opacity(0.82))
                            .lineSpacing(5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.mamTarjeta)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.mamFondo.opacity(0.06), lineWidth: 1)
                    }
                    .shadow(color: Color.mamFondo.opacity(0.07), radius: 10, y: 5)

                    HStack(alignment: .top, spacing: 12) {
                        DatoNawalCard(
                            icono: fechaTexto == nil ? "circle.grid.3x3.fill" : "calendar",
                            titulo: fechaTexto == nil ? "Calendario" : "Tu fecha",
                            valor: fechaTexto ?? "Cholq’ij · 20 energías",
                            acento: .mamOro
                        )

                        DatoNawalCard(
                            icono: "sun.max.fill",
                            titulo: tituloEnergia,
                            valor: energia,
                            acento: .mamJade
                        )
                    }

                    Text("Cada nawal es una invitación a reconocer la energía que acompaña tu camino.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.mamFondo.opacity(0.56))
                        .padding(.horizontal, 18)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 36)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var encabezado: some View {
        HStack {
            Button(action: { cerrarVista() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.mamFondo)
                    .frame(width: 44, height: 44)
                    .background(Color.mamTarjeta)
                    .clipShape(Circle())
                    .shadow(color: Color.mamFondo.opacity(0.08), radius: 8, y: 4)
            }
            .accessibilityLabel("Regresar al catálogo")

            Spacer()

            Text("DETALLE SAGRADO")
                .font(.system(size: 11, weight: .black, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(Color.mamJade)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color.mamJade.opacity(0.09))
                .clipShape(Capsule())
        }
    }

    private var piezaPrincipal: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.mamFondo, Color.mamJade],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(Color.mamAmarillo.opacity(0.13), lineWidth: 1)
                .frame(width: 250, height: 250)
                .offset(x: 155, y: -150)

            Circle()
                .fill(Color.mamAmarillo.opacity(0.08))
                .frame(width: 150, height: 150)
                .offset(x: -165, y: 190)

            VStack(spacing: 10) {
                Text(numeroEnergia.map { "ENERGÍA \($0)  ·  TU NAWAL ES" } ?? "NAWAL DEL CHOLQ’IJ")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Color.mamAmarillo)

                Text(nawal.nombre)
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(Color.mamCrema)
                    .minimumScaleFactor(0.7)

                Text(subtitulo)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.mamCrema.opacity(0.72))

                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding(7)
                    .background(Color.mamCrema)
                    .clipShape(RoundedRectangle(cornerRadius: 27, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 27, style: .continuous)
                            .stroke(Color.mamAmarillo.opacity(0.72), lineWidth: 2)
                    }
                    .shadow(color: .black.opacity(0.25), radius: 18, y: 10)
                    .padding(.top, 6)
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.mamFondo.opacity(0.18), radius: 18, y: 10)
    }
}

private struct DatoNawalCard: View {
    let icono: String
    let titulo: String
    let valor: String
    let acento: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icono)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(acento)
                .frame(width: 36, height: 36)
                .background(acento.opacity(0.11))
                .clipShape(Circle())

            Text(titulo.uppercased())
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(1)
                .foregroundStyle(Color.mamFondo.opacity(0.5))

            Text(valor)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(Color.mamFondo)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 142, alignment: .topLeading)
        .padding(16)
        .background(Color.mamTarjeta)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.mamFondo.opacity(0.06), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        DetalleNawalView(
            nawal: PaletteNawalItem(
                nombre: "Imox",
                esDestacado: true,
                nombreImagen: "Imox"
            )
        )
    }
}
