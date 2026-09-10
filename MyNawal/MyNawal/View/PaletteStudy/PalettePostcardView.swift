import SwiftUI

struct PalettePostcardView: View {
    let content: PaletteStudyContent
    let nawal: PaletteNawalItem?
    let numeroEnergia: Int?
    let fecha: Date?

    init(
        content: PaletteStudyContent,
        nawal: PaletteNawalItem? = nil,
        numeroEnergia: Int? = nil,
        fecha: Date? = nil
    ) {
        self.content = content
        self.nawal = nawal
        self.numeroEnergia = numeroEnergia
        self.fecha = fecha
    }

    private var imagenNawal: String? {
        nawal?.nombreImagen
    }

    private var nombreNawal: String {
        nawal?.nombre ?? "Tu Nawal"
    }

    private var fechaTexto: String {
        guard let fecha else { return "Calcula tu fecha para descubrirlo" }
        return fecha.formatted(
            Date.FormatStyle(date: .long, time: .omitted, locale: Locale(identifier: "es_MX"))
        )
    }

    private var encabezadoEnergia: String {
        numeroEnergia.map { "ENERGÍA \($0)  ·  MI NAWAL ES" } ?? "MI NAWAL ES"
    }

    private var energiaTexto: String {
        nawal?.energia ?? "Tu energía aparecerá aquí"
    }

    var body: some View {
        ZStack {
            NawalBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 9) {
                        Text("TU RECUERDO")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(Color.mamJade)

                        Text(content.postcardTitle)
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(Color.mamFondo)

                        Text("Guarda o comparte la energía que acompaña tu camino.")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.mamFondo.opacity(0.64))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    postal

                    HStack(spacing: 12) {
                        PalettePostcardAction(title: "Guardar", icon: "arrow.down", background: .mamJade)
                        PalettePostcardAction(title: "Compartir", icon: "square.and.arrow.up", background: .mamFondo)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.mamJade)
                        Text("Tu postal está lista para llevarla contigo")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.mamFondo.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 38)
            }
        }
    }

    private var postal: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.mamFondo, Color.mamJade, Color.mamFondo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(Color.mamAmarillo.opacity(0.16), lineWidth: 1)
                .frame(width: 280, height: 280)
                .offset(x: 155, y: -190)

            Circle()
                .fill(Color.mamAmarillo.opacity(0.07))
                .frame(width: 210, height: 210)
                .offset(x: -170, y: 225)

            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(Color.mamAmarillo.opacity(0.65))
                        .frame(height: 1)

                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.mamAmarillo)

                    Rectangle()
                        .fill(Color.mamAmarillo.opacity(0.65))
                        .frame(height: 1)
                }

                Text(encabezadoEnergia)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Color.mamAmarillo)

                Text(nombreNawal)
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(Color.mamCrema)

                Group {
                    if let imagenNawal {
                        ImagenNawalLocal(nombre: imagenNawal)
                            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.questionmark")
                                .font(.system(size: 40, weight: .light))
                            Text("Sin calcular")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(Color.mamJade.opacity(0.7))
                    }
                }
                .frame(width: 176, height: 176)
                .padding(7)
                .background(Color.mamCrema)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.mamAmarillo.opacity(0.7), lineWidth: 2)
                }
                .shadow(color: .black.opacity(0.25), radius: 15, y: 8)

                Text(fechaTexto)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mamCrema)

                Text(energiaTexto)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.mamCrema.opacity(0.72))

                HStack(spacing: 9) {
                    PaletteDot(color: .mamJadeClaro)
                    PaletteDot(color: .mamRojo)
                    PaletteDot(color: .mamAmarillo)
                    PaletteDot(color: .mamMorado)
                    PaletteDot(color: .mamAzul)
                }
                .padding(.top, 2)
            }
            .padding(26)
        }
        .frame(height: 500)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.mamOro, lineWidth: 2)
                .padding(6)
        }
        .shadow(color: Color.mamFondo.opacity(0.2), radius: 20, y: 12)
    }
}
