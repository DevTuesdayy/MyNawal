import SwiftUI

struct PalettePostcardView: View {
    let draft: NawalPostcardDraft?
    let onCalculate: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    @State private var isShowingSelfie = false
    @State private var selfieImage: UIImage?
    @State private var previewSelfie: UIImage?
    @State private var editorSection: PostcardEditorSection = .design
    @State private var appearance = PostcardAppearance()
    @State private var renderedPostcard: RenderedPostcard?
    @State private var isSavingPostcard = false
    @State private var didSavePostcard = false
    @State private var exportErrorMessage: String?
    @State private var shouldOfferSettings = false
    @State private var postcardRenderTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Tu postal Nawal")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .accessibilityAddTraits(.isHeader)
                    Text(draft == nil
                         ? "Comienza descubriendo tu nawal"
                         : selfieImage == nil
                            ? "Tu nawal, listo para crear tu postal"
                            : "Revisa tu postal y prepárala para compartir")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                    SeparadorHilos()
                }

                if let draft {
                    if let selfieImage {
                        completedPostcard(draft, selfieImage: selfieImage)
                            .id(draft)
                            .nawalEntrance()
                    } else {
                        postcardDetails(draft)
                            .id(draft)
                            .nawalEntrance()

                        selfieSection()
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "camera.on.rectangle")
                            .font(.system(size: 44, weight: .light))
                            .foregroundStyle(Color.mamJade)
                            .accessibilityHidden(true)
                        Text("Primero calcula tu Nawal")
                            .font(.headline)
                        Text("Ingresa tu fecha de nacimiento y toca Crear mi postal en tu resultado.")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .superficieEstuco()
                }

                Button(action: onCalculate) {
                    Label(draft == nil ? "Calcular mi Nawal" : "Volver a calcular", systemImage: "calendar")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color.mamBlanco)
                        .padding(18)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(NawalPressStyle())
            }
            .foregroundStyle(Color.mamFondo)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 520)
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .background(FondoEstuco().ignoresSafeArea())
        .fullScreenCover(isPresented: $isShowingSelfie) {
            if let draft {
                NawalSelfieView(draft: draft) { image in
                    // Decode a small preview once per photo, not for each gesture update.
                    previewSelfie = image.preparingThumbnail(of: CGSize(width: 1200, height: 1200)) ?? image
                    appearance.photo = PostcardPhotoSettings()
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.24)) {
                        selfieImage = image
                    }
                    schedulePostcardPreparation(draft: draft, selfieImage: image)
                }
            }
        }
        .onChange(of: draft) { oldDraft, newDraft in
            guard oldDraft != newDraft else { return }
            postcardRenderTask?.cancel()
            selfieImage = nil
            previewSelfie = nil
            editorSection = .design
            appearance = PostcardAppearance()
            renderedPostcard = nil
            didSavePostcard = false
        }
        .onDisappear {
            postcardRenderTask?.cancel()
        }
        .onChange(of: appearance) { _, _ in
            guard let draft, let selfieImage else { return }
            schedulePostcardPreparation(draft: draft, selfieImage: selfieImage)
        }
        .onAppear {
            // Resume a preparation cancelled when leaving the tab.
            if renderedPostcard == nil, let draft, let selfieImage {
                schedulePostcardPreparation(draft: draft, selfieImage: selfieImage)
            }
        }
        .alert(
            "No se pudo completar la acción",
            isPresented: Binding(
                get: { exportErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        exportErrorMessage = nil
                        shouldOfferSettings = false
                    }
                }
            )
        ) {
            if shouldOfferSettings {
                Button("Abrir Configuración") {
                    openSettings()
                }
            }
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(exportErrorMessage ?? "Ocurrió un error inesperado.")
        }
    }

    private func postcardDetails(_ draft: NawalPostcardDraft) -> some View {
        let nawal = draft.result.nawal
        return VStack(spacing: 16) {
            Text("Mi Nawal es")
                .font(.headline)
            Text("\(draft.result.energia) \(nawal.nombre)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamJade)
                .accessibilityLabel("Energía \(draft.result.energia), nawal \(nawal.nombre)")

            ImagenNawalLocal(nombre: nawal.nombreImagen)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(8)
                .superficieEstuco()
                .accessibilityHidden(true)

            Text(nawal.informacion.significado)
                .font(.system(.title3, design: .rounded, weight: .medium))
            Text("Animal o representación: \(nawal.informacion.animal)")
                .font(.body)
            Text("Elemento: \(nawal.informacion.elemento)")
                .font(.body)
            SeparadorHilos()
            Text(draft.birthDateText)
                .font(.headline)
                .accessibilityLabel("Fecha de nacimiento: \(draft.birthDateText)")
            Text(nawal.informacion.energia)
                .font(.subheadline)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }

    private func selfieSection() -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color.mamJade)
                    .accessibilityHidden(true)
                Text("Añade tu selfie")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text("La usaremos para crear tu postal en el siguiente paso.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.72))
            }
            .padding(.vertical, 8)

            Button {
                isShowingSelfie = true
            } label: {
                Label("Tomar mi selfie", systemImage: "camera.fill")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.mamBlanco)
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(NawalPressStyle())
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }

    private func completedPostcard(
        _ draft: NawalPostcardDraft,
        selfieImage: UIImage
    ) -> some View {
        VStack(spacing: 18) {
            PostcardEditorView(
                draft: draft,
                selfieImage: previewSelfie ?? selfieImage,
                selectedSection: $editorSection,
                appearance: $appearance
            ) {
                isShowingSelfie = true
            }

            exportActions(draft)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }

    @ViewBuilder
    private func exportActions(_ draft: NawalPostcardDraft) -> some View {
        if let renderedPostcard {
            exportActionsLayout {
                Button(action: savePostcard) {
                    Group {
                        if isSavingPostcard {
                            ProgressView()
                                .tint(Color.mamBlanco)
                        } else {
                            Label(
                                didSavePostcard ? "Guardada" : "Guardar",
                                systemImage: didSavePostcard ? "checkmark" : "arrow.down.to.line"
                            )
                        }
                    }
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.mamJade)
                .disabled(isSavingPostcard || didSavePostcard)

                ShareLink(
                    item: ShareablePostcard(pngData: renderedPostcard.pngData),
                    preview: SharePreview(
                        "Mi Nawal: \(draft.result.energia) \(draft.result.nawal.nombre)",
                        image: Image(uiImage: renderedPostcard.image)
                    )
                ) {
                    Label("Compartir", systemImage: "square.and.arrow.up")
                        .font(.system(.headline, design: .rounded))
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.bordered)
                .tint(Color.mamJade)
            }
        } else {
            HStack(spacing: 10) {
                ProgressView()
                    .tint(Color.mamJade)
                Text("Preparando imagen…")
                    .font(.system(.subheadline, design: .rounded))
            }
            .frame(maxWidth: .infinity, minHeight: 52)
        }
    }

    private var exportActionsLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(spacing: 12))
    }

    private func preparePostcard(
        draft: NawalPostcardDraft,
        selfieImage: UIImage
    ) {
        do {
            renderedPostcard = try PostcardExportService.render(
                draft: draft,
                selfieImage: selfieImage,
                appearance: appearance
            )
            didSavePostcard = false
        } catch {
            renderedPostcard = nil
            presentExportError(error)
        }
    }

    private func schedulePostcardPreparation(
        draft: NawalPostcardDraft,
        selfieImage: UIImage
    ) {
        postcardRenderTask?.cancel()
        renderedPostcard = nil
        didSavePostcard = false

        postcardRenderTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled else { return }
            preparePostcard(draft: draft, selfieImage: selfieImage)
            postcardRenderTask = nil
        }
    }

    private func savePostcard() {
        guard let renderedPostcard, !isSavingPostcard else { return }

        isSavingPostcard = true
        Task {
            do {
                try await PostcardExportService.saveToPhotoLibrary(renderedPostcard.pngData)
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
                    didSavePostcard = true
                }
            } catch {
                presentExportError(error)
            }
            isSavingPostcard = false
        }
    }

    private func presentExportError(_ error: Error) {
        let exportError = error as? PostcardExportError
        shouldOfferSettings = exportError == .photoAccessDenied
        exportErrorMessage = error.localizedDescription
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url)
    }
}

#Preview("Sin resultado") {
    PalettePostcardView(draft: nil, onCalculate: {})
}

#Preview("Con resultado") {
    PalettePostcardView(
        draft: NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        ),
        onCalculate: {}
    )
}
