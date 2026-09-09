import SwiftUI

struct PalettePostcardView: View {
    let content: PaletteStudyContent

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.postcardTitle)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(content.postcardSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                }

                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.mamBlanco, Color.mamBlanco, Color.mamArena.opacity(0.34)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 480)
                    .overlay {
                        VStack(spacing: 14) {
                            Text("Mi Nawal es")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(Color.mamFondo)

                            Text(content.selectedNawal.subtitle)
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundStyle(Color.mamFondo)

                            Text("(Cocodrilo / Agua)")
                                .font(.subheadline)
                                .foregroundStyle(Color.mamFondo.opacity(0.82))

                            LocalNawalImage(name: "Imox")
                                .padding(10)
                                .frame(width: 146, height: 146)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(Color.mamJade.opacity(0.5), lineWidth: 2)
                                }
                                .shadow(color: Color.mamFondo.opacity(0.1), radius: 10, y: 4)

                            VStack(spacing: 6) {
                                Text(content.birthDateText)
                                    .font(.headline)
                                    .foregroundStyle(Color.mamFondo)
                                Text(content.selectedNawal.energyText)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.mamFondo.opacity(0.8))
                            }

                            HStack(spacing: 10) {
                                PaletteDot(color: .mamJade)
                                PaletteDot(color: .mamRojo)
                                PaletteDot(color: .mamAmarillo)
                                PaletteDot(color: .mamMorado)
                                PaletteDot(color: .mamAzul)
                            }
                        }
                        .padding(24)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color.mamJade, lineWidth: 3)
                    )

                HStack(spacing: 12) {
                    PalettePostcardAction(title: "Guardar", icon: "arrow.down", background: .mamJade)
                    PalettePostcardAction(title: "Compartir", icon: "square.and.arrow.up", background: .mamFondo)
                }

                HStack(spacing: 12) {
                    PaletteSampleStrip(color: .mamArena, title: "Superficie", darkText: true)
                    PaletteSampleStrip(color: .mamRojo, title: "Sello de energia")
                    PaletteSampleStrip(color: .mamAmarillo, title: "Acento", darkText: true)
                }
            }
            .padding(20)
        }
        .background(Color.mamBlanco.ignoresSafeArea())
    }
}
