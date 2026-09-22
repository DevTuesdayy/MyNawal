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
    @State private var showingCustomization = false
    @State private var changePhotoAfterDismiss = false

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

            Button {
                showingCustomization = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3.weight(.semibold))
                    .frame(width: 52, height: 52)
                    .foregroundStyle(Color.mamBlanco)
                    .background(Color.mamJade, in: Circle())
            }
            .buttonStyle(NawalPressStyle())
            .accessibilityLabel("Personalizar postal")
            .accessibilityHint("Abre diseños, colores, foto y texto")
        }
        .foregroundStyle(Color.mamFondo)
        .sheet(isPresented: $showingCustomization, onDismiss: {
            if changePhotoAfterDismiss {
                changePhotoAfterDismiss = false
                onChangePhoto()
            }
        }) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        NawalPostcardCanvas(draft: draft, selfieImage: selfieImage, appearance: appearance)
                            .frame(maxWidth: 180)
                        customizationPanel
                    }
                    .padding(20)
                }
                .background(FondoEstuco().ignoresSafeArea())
                .navigationTitle("Personalizar postal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Listo") { showingCustomization = false }
                    }
                }
            }
            .tint(Color.mamJade)
            .foregroundStyle(Color.mamFondo)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private var customizationPanel: some View {
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
            colorsPanel
        case .photo:
            VStack(alignment: .leading, spacing: 10) {
                panelTitle("Tu selfie")
                PostcardPhotoControls(image: selfieImage, settings: $appearance.photo)
                Text("Puedes elegir otra foto conservando tu nawal y su energía.")
                    .font(.subheadline)
                Button {
                    changePhotoAfterDismiss = true
                    showingCustomization = false
                } label: {
                    Label("Cambiar selfie", systemImage: "arrow.triangle.2.circlepath.camera")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .tint(Color.mamJade)
            }
        case .text:
            textPanel
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
                                PostcardBackground(design: design, paper: appearance.background)
                                Image(systemName: "person.crop.rectangle")
                                    .font(.title)
                                    .foregroundStyle(Color.mamJade)
                                PostcardFrame(appearance: PostcardAppearance(
                                    design: design, thickness: appearance.thickness,
                                    background: appearance.background,
                                    frameColor: appearance.frameColor, accentColor: appearance.accentColor
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

    private var colorsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            panelTitle("Combinaciones")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(PostcardPalette.allCases) { palette in
                    let selected = appearance.background == palette.paper
                        && appearance.frameColor == palette.ink && appearance.accentColor == palette.ink
                    Button {
                        appearance.apply(palette)
                    } label: {
                        HStack(spacing: 8) {
                            Circle().fill(palette.ink.color)
                                .frame(width: 20, height: 20)
                            Text(palette.title).font(.subheadline.weight(.semibold))
                            Spacer(minLength: 0)
                            if selected { Image(systemName: "checkmark").accessibilityHidden(true) }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .foregroundStyle(Color.mamFondo)
                        .background(palette.paper.color, in: RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(selected ? Color.mamJade : .clear, lineWidth: 2)
                        }
                    }
                    .buttonStyle(NawalPressStyle())
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }
            panelTitle("Ajustar por separado")
            Picker("Fondo", selection: $appearance.background) {
                ForEach(PostcardPaper.allCases) { paper in
                    Text(paper.title).tag(paper)
                }
            }
            inkPicker("Marco", selection: $appearance.frameColor)
            inkPicker("Acentos", selection: $appearance.accentColor)
            Text("Fondos claros y tonos oscuros para mantener legible la información.")
                .font(.footnote)
                .foregroundStyle(Color.mamFondo)
        }
        .pickerStyle(.menu)
        .tint(Color.mamJade)
    }

    private func inkPicker(_ title: String, selection: Binding<PostcardInk?>) -> some View {
        Picker(title, selection: selection) {
            Text("Original").tag(Optional<PostcardInk>.none)
            ForEach(PostcardInk.allCases) { ink in
                Text(ink.title).tag(Optional(ink))
            }
        }
        .frame(minHeight: 44)
    }

    private var textPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            panelTitle("Texto personal")

            VStack(alignment: .leading, spacing: 6) {
                TextField("Tu nombre (opcional)", text: $appearance.text.personName)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .onChange(of: appearance.text.personName) { _, value in
                        appearance.text.personName = String(value.prefix(PostcardTextSettings.nameLimit))
                    }
                Text("\(appearance.text.personName.count)/\(PostcardTextSettings.nameLimit)")
                    .font(.caption2)
                    .foregroundStyle(Color.mamFondo.opacity(0.65))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(12)
            .background(Color.white.opacity(0.44), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                TextField("Mensaje corto (opcional)", text: $appearance.text.message, axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
                    .submitLabel(.done)
                    .onChange(of: appearance.text.message) { _, value in
                        appearance.text.message = String(value.prefix(PostcardTextSettings.messageLimit))
                    }
                Text("\(appearance.text.message.count)/\(PostcardTextSettings.messageLimit)")
                    .font(.caption2)
                    .foregroundStyle(Color.mamFondo.opacity(0.65))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(12)
            .background(Color.white.opacity(0.44), in: RoundedRectangle(cornerRadius: 12))

            Picker("Tipografía", selection: $appearance.text.typography) {
                ForEach(PostcardTypography.allCases) { typography in
                    Text(typography.title).tag(typography)
                }
            }
            .pickerStyle(.segmented)

            panelTitle("Datos visibles")
            VStack(spacing: 0) {
                textToggle("Fecha de nacimiento", isOn: $appearance.text.showsDate)
                Divider()
                textToggle("Animal o representación", isOn: $appearance.text.showsAnimal)
                Divider()
                textToggle("Elemento", isOn: $appearance.text.showsElement)
                Divider()
                textToggle("Asociaciones simbólicas", isOn: $appearance.text.showsEnergyAssociations)
            }
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.44), in: RoundedRectangle(cornerRadius: 12))

            Text("El número de energía y el nombre del nawal siempre permanecen visibles.")
                .font(.footnote)
                .foregroundStyle(Color.mamFondo.opacity(0.72))

            Button("Restablecer texto", systemImage: "arrow.counterclockwise") {
                appearance.text = PostcardTextSettings()
            }
            .frame(minHeight: 44)
            .tint(Color.mamJade)
        }
    }

    private func textToggle(_ title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .font(.system(.subheadline, design: .rounded, weight: .medium))
            .tint(Color.mamJade)
            .frame(minHeight: 48)
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
