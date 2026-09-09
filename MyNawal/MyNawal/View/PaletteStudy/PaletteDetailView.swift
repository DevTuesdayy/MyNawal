import SwiftUI

struct PaletteDetailView: View {
    let content: PaletteStudyContent

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.mamFondo, Color(red: 2 / 255, green: 32 / 255, blue: 29 / 255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Spacer()
                        Text("Tu Nawal")
                            .font(.headline.bold())
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .opacity(0)
                    }
                    .foregroundStyle(Color.mamBlanco)

                    OrnamentLine()

                    VStack(spacing: 6) {
                        Text(content.selectedNawal.title)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.mamBlanco)

                        Text(content.selectedNawal.subtitle)
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(Color.mamAmarillo)

                        Text("(Cocodrilo / Agua)")
                            .font(.headline)
                            .foregroundStyle(Color.mamBlanco.opacity(0.86))
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .fill(Color.mamJade.opacity(0.12))
                            .frame(width: 236, height: 236)

                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.mamArena)
                            .frame(width: 192, height: 192)
                            .overlay {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.mamAmarillo.opacity(0.55), lineWidth: 2)
                                    .padding(2)
                            }

                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.mamBlanco)
                            .frame(width: 168, height: 168)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(Color.mamJade, lineWidth: 5)
                            }

                        LocalNawalImage(name: "Imox")
                            .padding(16)
                            .frame(width: 164, height: 164)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    HStack(spacing: 12) {
                        ForEach(0..<5, id: \.self) { _ in
                            Circle()
                                .fill(Color.mamRojo)
                                .frame(width: 12, height: 12)
                        }
                    }

                    Text(content.selectedNawal.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.mamBlanco.opacity(0.84))
                        .padding(.horizontal, 12)
                        .frame(maxWidth: 340)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Fecha correspondiente")
                                .font(.caption.bold())
                                .foregroundStyle(Color.mamAmarillo)
                            Spacer()
                            SmallOrnament()
                        }

                        Text(content.selectedNawal.dateText)
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color.mamBlanco)

                        Divider()
                            .overlay(Color.mamArena.opacity(0.35))

                        Text("Energia")
                            .font(.caption.bold())
                            .foregroundStyle(Color.mamAmarillo)

                        Text(content.selectedNawal.energyText)
                            .font(.body)
                            .foregroundStyle(Color.mamBlanco.opacity(0.92))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color.black.opacity(0.18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.mamArena.opacity(0.55), lineWidth: 1.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    Button(action: {}) {
                        Label(content.selectedNawal.actionTitle, systemImage: "camera")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(Color.mamBlanco)
                            .background(Color.mamJade)
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.mamArena.opacity(0.4), lineWidth: 1.5)
                                    .padding(1)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }
        }
    }
}
