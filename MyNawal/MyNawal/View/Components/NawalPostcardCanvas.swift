import SwiftUI
import UIKit

struct NawalPostcardCanvas: View {
    let draft: NawalPostcardDraft
    let selfieImage: UIImage

    var body: some View {
        GeometryReader { proxy in
            let unit = proxy.size.width / 360
            let nawal = draft.result.nawal

            ZStack {
                FondoEstuco()

                LinearGradient(
                    colors: [
                        Color.mamAmarillo.opacity(0.13),
                        Color.clear,
                        Color.mamJade.opacity(0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 8 * unit) {
                    Text("MI NAWAL ES")
                        .font(.system(size: 11 * unit, weight: .semibold, design: .rounded))
                        .tracking(1.8 * unit)
                        .foregroundStyle(Color.mamFondo.opacity(0.7))

                    Text("\(draft.result.energia) \(nawal.nombre)")
                        .font(.system(size: 30 * unit, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamJade)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(nawal.informacion.significado)
                        .font(.system(size: 13 * unit, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.82))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    selfieFrame(unit: unit, nawalImageName: nawal.nombreImagen)

                    HStack(spacing: 8 * unit) {
                        postcardFact(
                            title: "Animal",
                            value: nawal.informacion.animal,
                            systemImage: "pawprint.fill",
                            unit: unit
                        )
                        postcardFact(
                            title: "Elemento",
                            value: nawal.informacion.elemento,
                            systemImage: "sparkles",
                            unit: unit
                        )
                    }

                    postcardDivider(unit: unit)

                    Text(draft.birthDateText)
                        .font(.system(size: 12 * unit, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("Conecta con tu esencia  •  Honra tu origen")
                        .font(.system(size: 9.5 * unit, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.64))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .multilineTextAlignment(.center)
                .padding(18 * unit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24 * unit, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24 * unit, style: .continuous)
                    .strokeBorder(Color.mamFondo, lineWidth: 3 * unit)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 18 * unit, style: .continuous)
                    .strokeBorder(Color.mamAmarillo.opacity(0.9), lineWidth: 1.5 * unit)
                    .padding(7 * unit)
            }
        }
        .aspectRatio(4 / 5, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "Postal Nawal. Energía \(draft.result.energia), \(draft.result.nawal.nombre). "
            + "Animal o representación: \(draft.result.nawal.informacion.animal). "
            + "Elemento: \(draft.result.nawal.informacion.elemento). Fecha: \(draft.birthDateText)."
        )
    }

    private func selfieFrame(unit: CGFloat, nawalImageName: String) -> some View {
        Image(uiImage: selfieImage)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 205 * unit)
            .clipped()
            .overlay {
                LinearGradient(
                    colors: [.clear, Color.mamFondo.opacity(0.22)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 18 * unit, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18 * unit, style: .continuous)
                    .strokeBorder(Color.mamArena, lineWidth: 2 * unit)
            }
            .overlay(alignment: .topTrailing) {
                ImagenNawalLocal(nombre: nawalImageName)
                    .frame(width: 68 * unit, height: 68 * unit)
                    .padding(5 * unit)
                    .background(Color.mamBlanco.opacity(0.94), in: RoundedRectangle(cornerRadius: 14 * unit))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14 * unit)
                            .strokeBorder(Color.mamAmarillo, lineWidth: 1.5 * unit)
                    }
                    .shadow(color: Color.mamFondo.opacity(0.22), radius: 4 * unit, y: 2 * unit)
                    .padding(10 * unit)
            }
    }

    private func postcardFact(
        title: String,
        value: String,
        systemImage: String,
        unit: CGFloat
    ) -> some View {
        HStack(spacing: 5 * unit) {
            Image(systemName: systemImage)
                .font(.system(size: 10 * unit, weight: .semibold))
                .foregroundStyle(Color.mamJade)

            VStack(alignment: .leading, spacing: 1 * unit) {
                Text(title.uppercased())
                    .font(.system(size: 7.5 * unit, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.55))
                Text(value)
                    .font(.system(size: 10 * unit, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.mamFondo)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 9 * unit)
        .frame(maxWidth: .infinity, minHeight: 35 * unit)
        .background(Color.mamBlanco.opacity(0.72), in: RoundedRectangle(cornerRadius: 10 * unit))
        .overlay {
            RoundedRectangle(cornerRadius: 10 * unit)
                .strokeBorder(Color.mamArena.opacity(0.7), lineWidth: unit)
        }
    }

    private func postcardDivider(unit: CGFloat) -> some View {
        HStack(spacing: 7 * unit) {
            Rectangle()
                .fill(Color.mamJade.opacity(0.75))
                .frame(height: unit)
            Image(systemName: "diamond.fill")
                .font(.system(size: 7 * unit))
                .foregroundStyle(Color.mamRojo)
            Rectangle()
                .fill(Color.mamJade.opacity(0.75))
                .frame(height: unit)
        }
        .frame(maxWidth: 210 * unit)
        .accessibilityHidden(true)
    }
}

#Preview {
    NawalPostcardCanvas(
        draft: NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        ),
        selfieImage: UIImage(named: NawalCatalogo.items[0].nombreImagen) ?? UIImage()
    )
    .frame(width: 360)
    .padding()
    .background(Color.mamFondo)
}
