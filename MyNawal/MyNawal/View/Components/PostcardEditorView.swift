import SwiftUI

enum PostcardEditorSection: String, CaseIterable, Identifiable {
    case design, colors, photo, text

    var id: Self { self }

    var title: String {
        switch self {
        case .design: "Diseño"
        case .colors: "Colores"
        case .photo: "Foto"
        case .text: "Texto"
        }
    }

    var symbol: String {
        switch self {
        case .design: "rectangle.3.group"
        case .colors: "paintpalette"
        case .photo: "person.crop.rectangle"
        case .text: "textformat"
        }
    }
}

/// The parent owns the editing session so switching panels never replaces the photo or draft.
struct PostcardEditorView: View {
    let draft: NawalPostcardDraft
    let selfieImage: UIImage
    @Binding var selectedSection: PostcardEditorSection
    @Binding var appearance: PostcardAppearance
    let onChangePhoto: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8),
              count: dynamicTypeSize.isAccessibilitySize ? 2 : 4)
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("Tu postal")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .accessibilityAddTraits(.isHeader)
                Text("Vista previa")
                    .font(.caption)
                    .foregroundStyle(Color.mamFondo.opacity(0.7))
            }

            // Keep the existing canvas alive when changing panels; no PNG rendering here.
            NawalPostcardCanvas(draft: draft, selfieImage: selfieImage, appearance: appearance)
                .frame(maxWidth: 300)
                .shadow(color: Color.mamFondo.opacity(0.12), radius: 5, y: 3)

            VStack(alignment: .leading, spacing: 16) {
                Text("Personaliza tu postal")
                    .font(.system(.headline, design: .rounded))
                    .accessibilityAddTraits(.isHeader)

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(PostcardEditorSection.allCases) { section in
                        sectionButton(section)
                    }
                }

                panel
                    .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .id(selectedSection)
                    .transition(.opacity)
            }
            .padding(16)
            .background(Color.mamBlanco.opacity(0.8), in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.mamArena.opacity(0.7), lineWidth: 1)
            }
        }
        .foregroundStyle(Color.mamFondo)
    }

    private func sectionButton(_ section: PostcardEditorSection) -> some View {
        let selected = selectedSection == section
        return Button {
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.16)) {
                selectedSection = section
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: section.symbol)
                    .font(.system(.body, weight: .semibold))
                    .accessibilityHidden(true)
                Text(section.title)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.vertical, 8)
            .foregroundStyle(selected ? Color.mamBlanco : Color.mamFondo)
            .background(selected ? Color.mamJade : Color.mamArena.opacity(0.2),
                        in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(selected ? Color.mamJade : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(NawalPressStyle())
        .accessibilityAddTraits(selected ? .isSelected : [])
        .accessibilityHint("Muestra la sección \(section.title)")
    }

    @ViewBuilder
    private var panel: some View {
        switch selectedSection {
        case .design:
            designPanel
        case .colors:
            VStack(alignment: .leading, spacing: 10) {
                panelTitle("Paleta actual")
                HStack(spacing: 12) {
                    colorSample("Jade", color: .mamJade)
                    colorSample("Arena", color: .mamArena)
                    colorSample("Crema", color: .mamBlanco)
                }
                Text("Los colores originales de tu postal.")
                    .font(.subheadline)
            }
        case .photo:
            VStack(alignment: .leading, spacing: 10) {
                panelTitle("Tu selfie")
                Text("Puedes elegir otra foto conservando tu nawal y su energía.")
                    .font(.subheadline)
                Button(action: onChangePhoto) {
                    Label("Cambiar selfie", systemImage: "arrow.triangle.2.circlepath.camera")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .tint(Color.mamJade)
            }
        case .text:
            VStack(alignment: .leading, spacing: 10) {
                panelTitle("Datos de tu postal")
                Text("\(draft.result.energia) \(draft.result.nawal.nombre)")
                    .font(.headline)
                Text(draft.birthDateText)
                    .font(.subheadline)
                Text("Incluye el significado, el animal y el elemento de tu nawal.")
                    .font(.subheadline)
            }
        }
    }

    private var designPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            panelTitle("Elige un diseño")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(PostcardDesign.allCases) { design in
                    Button {
                        appearance.design = design
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                PostcardBackground(design: design)
                                Image(systemName: "person.crop.rectangle")
                                    .font(.title)
                                    .foregroundStyle(Color.mamJade)
                                PostcardFrame(appearance: PostcardAppearance(
                                    design: design, thickness: appearance.thickness
                                ), unit: 0.7)
                            }
                            .frame(height: 76)
                            .clipShape(RoundedRectangle(cornerRadius: 17))
                            Text(design.title)
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .fixedSize(horizontal: false, vertical: true)
                            Image(systemName: appearance.design == design ? "checkmark.circle.fill" : "circle")
                                .accessibilityHidden(true)
                        }
                        .foregroundStyle(Color.mamJade)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.mamArena.opacity(appearance.design == design ? 0.25 : 0.08),
                                    in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(NawalPressStyle())
                    .accessibilityLabel(design.title)
                    .accessibilityAddTraits(appearance.design == design ? .isSelected : [])
                }
            }
            Picker("Grosor del marco", selection: $appearance.thickness) {
                ForEach(PostcardFrameThickness.allCases) { thickness in
                    Text(thickness.title).tag(thickness)
                }
            }
            .pickerStyle(.menu)
            .tint(Color.mamJade)
            .frame(minHeight: 44)
        }
    }

    private func panelTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(.subheadline, design: .rounded, weight: .bold))
            .accessibilityAddTraits(.isHeader)
    }

    private func colorSample(_ name: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 28, height: 28)
                .overlay { Circle().strokeBorder(Color.mamFondo.opacity(0.2), lineWidth: 1) }
            Text(name).font(.caption)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
    }
}

#Preview("Editor") {
    ScrollView {
        PostcardEditorView(
            draft: NawalPostcardDraft(
                result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
                birthDateText: "10 de diciembre de 1954"
            ),
            selfieImage: UIImage(named: "SelfieDemo") ?? UIImage(),
            selectedSection: .constant(.design),
            appearance: .constant(PostcardAppearance()),
            onChangePhoto: {}
        )
        .padding(24)
    }
    .background(FondoEstuco())
}
