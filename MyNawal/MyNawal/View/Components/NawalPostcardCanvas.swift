import SwiftUI
import UIKit

struct NawalPostcardCanvas: View {
    let draft: NawalPostcardDraft
    let selfieImage: UIImage
    var appearance = PostcardAppearance()

    static func photoHeight(for text: PostcardTextSettings) -> CGFloat {
        let extraTextBlocks = (text.trimmedName.isEmpty ? 0 : 1)
            + (text.showsEnergyAssociations ? 1 : 0)
        return extraTextBlocks == 2 ? 188 : (extraTextBlocks == 1 ? 196 : 205)
    }

    var body: some View {
        GeometryReader { proxy in
            let unit = proxy.size.width / 360
            let nawal = draft.result.nawal
            let text = appearance.text
            let fontDesign = text.typography.fontDesign
            let photoHeight = Self.photoHeight(for: text)

            ZStack {
                PostcardBackground(design: appearance.design, paper: appearance.background)

                VStack(spacing: 8 * unit) {
                    if !text.trimmedName.isEmpty {
                        Text(text.trimmedName.uppercased())
                            .font(.system(size: 9 * unit, weight: .semibold, design: fontDesign))
                            .tracking(1.2 * unit)
                            .foregroundStyle(Color.mamFondo.opacity(0.62))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }

                    Text("MI NAWAL ES")
                        .font(.system(size: 11 * unit, weight: .semibold, design: fontDesign))
                        .tracking(1.8 * unit)
                        .foregroundStyle(Color.mamFondo.opacity(0.7))

                    Text("\(draft.result.energia) \(nawal.nombre)")
                        .font(.system(size: 30 * unit, weight: .bold, design: fontDesign))
                        .foregroundStyle(appearance.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)

                    Text(nawal.informacion.significado)
                        .font(.system(size: 13 * unit, weight: .medium, design: fontDesign))
                        .foregroundStyle(Color.mamFondo.opacity(0.82))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    PostcardPhotoWithBadge(
                        image: selfieImage,
                        settings: appearance.photo,
                        border: appearance.frameColor?.color ?? .mamArena,
                        ornament: appearance.ornament,
                        nawalImageName: nawal.nombreImagen,
                        unit: unit
                    )
                    .frame(height: photoHeight * unit)

                    if text.showsAnimal || text.showsElement {
                        HStack(spacing: 8 * unit) {
                            if text.showsAnimal {
                                postcardFact(
                                    title: "Animal",
                                    value: nawal.informacion.animal,
                                    systemImage: "pawprint.fill",
                                    unit: unit,
                                    fontDesign: fontDesign
                                )
                            }
                            if text.showsElement {
                                postcardFact(
                                    title: "Elemento",
                                    value: nawal.informacion.elemento,
                                    systemImage: "sparkles",
                                    unit: unit,
                                    fontDesign: fontDesign
                                )
                            }
                        }
                    }

                    postcardDivider(unit: unit)

                    if text.showsEnergyAssociations {
                        Text(nawal.informacion.energia)
                            .font(.system(size: 9.5 * unit, weight: .medium, design: fontDesign))
                            .foregroundStyle(Color.mamFondo.opacity(0.78))
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                    }

                    if text.showsDate {
                        Text(draft.birthDateText)
                            .font(.system(size: 12 * unit, weight: .semibold, design: fontDesign))
                            .foregroundStyle(Color.mamFondo)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Text(text.resolvedMessage)
                        .font(.system(size: 9.5 * unit, weight: .medium, design: fontDesign))
                        .foregroundStyle(Color.mamFondo.opacity(0.64))
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                }
                .multilineTextAlignment(.center)
                .padding(18 * unit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24 * unit, style: .continuous))
            .overlay {
                PostcardFrame(appearance: appearance, unit: unit)
            }
        }
        .aspectRatio(4 / 5, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        let text = appearance.text
        let nawal = draft.result.nawal
        var parts = ["Postal Nawal.", "Energía \(draft.result.energia), \(nawal.nombre)."]
        if !text.trimmedName.isEmpty { parts.append("Personalizada por \(text.trimmedName).") }
        if text.showsAnimal { parts.append("Animal o representación: \(nawal.informacion.animal).") }
        if text.showsElement { parts.append("Elemento: \(nawal.informacion.elemento).") }
        if text.showsEnergyAssociations { parts.append("Asociaciones simbólicas: \(nawal.informacion.energia).") }
        if text.showsDate { parts.append("Fecha: \(draft.birthDateText).") }
        if !text.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append("Mensaje: \(text.resolvedMessage).")
        }
        return parts.joined(separator: " ")
    }

    private func postcardFact(
        title: String,
        value: String,
        systemImage: String,
        unit: CGFloat,
        fontDesign: Font.Design
    ) -> some View {
        HStack(spacing: 5 * unit) {
            Image(systemName: systemImage)
                .font(.system(size: 10 * unit, weight: .semibold))
                .foregroundStyle(appearance.accent)

            VStack(alignment: .leading, spacing: 1 * unit) {
                Text(title.uppercased())
                    .font(.system(size: 7.5 * unit, weight: .bold, design: fontDesign))
                    .foregroundStyle(Color.mamFondo.opacity(0.55))
                Text(value)
                    .font(.system(size: 10 * unit, weight: .semibold, design: fontDesign))
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
                .fill(appearance.accent.opacity(0.75))
                .frame(height: unit)
            Image(systemName: "diamond.fill")
                .font(.system(size: 7 * unit))
                .foregroundStyle(appearance.accentColor?.color ?? .mamRojo)
            Rectangle()
                .fill(appearance.accent.opacity(0.75))
                .frame(height: unit)
        }
        .frame(maxWidth: 210 * unit)
        .accessibilityHidden(true)
    }
}

private extension PostcardTypography {
    var fontDesign: Font.Design {
        switch self {
        case .rounded: .rounded
        case .classic: .serif
        case .clean: .default
        }
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
