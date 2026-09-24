import SwiftUI

/// An independent editing session: a new calculator result never changes this draft.
struct SavedPostcardEditorView: View {
    let store: PostcardLibraryStore
    @State private var record: SavedPostcard
    @State private var appearance: PostcardAppearance
    @State private var section: PostcardEditorSection = .design
    @State private var selfie: UIImage?
    @State private var preview: UIImage?
    @State private var originalSelfieData: Data?
    @State private var hasNewPhoto = false
    @State private var showingSelfie = false
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var confirmation: String?
    @State private var discardChanges = false
    @State private var copyID = UUID()
    @State private var didSaveCopy = false
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(record: SavedPostcard, store: PostcardLibraryStore) {
        self.store = store
        _record = State(initialValue: record)
        _appearance = State(initialValue: record.appearance)
    }

    private var hasChanges: Bool {
        appearance != record.appearance || hasNewPhoto
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let selfie {
                    PostcardEditorView(
                        draft: record.draft, selfieImage: preview ?? selfie,
                        selectedSection: $section, appearance: $appearance
                    ) {
                        showingSelfie = true
                    }
                    .disabled(isSaving)

                    Button { save(asCopy: false) } label: {
                        Label("Actualizar postal", systemImage: "checkmark.circle")
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isSaving || !hasChanges)

                    Button { save(asCopy: true) } label: {
                        Label("Guardar una copia", systemImage: "plus.square.on.square")
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.bordered)
                    .disabled(isSaving || didSaveCopy)

                    if isSaving {
                        ProgressView("Guardando tu postal…")
                    }
                    if let confirmation {
                        Text(confirmation)
                            .font(.subheadline)
                            .accessibilityLabel(confirmation)
                            .transition(.opacity)
                    }
                } else if isLoading {
                    ProgressView("Abriendo tu postal…")
                } else {
                    Text("No se pudo recuperar la foto de esta postal.")
                    Button("Volver a intentar") {
                        Task { await load() }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(FondoEstuco().ignoresSafeArea())
        .foregroundStyle(Color.mamFondo)
        .navigationTitle("Editar postal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if hasChanges { discardChanges = true } else { dismiss() }
                } label: {
                    Label("Mis postales", systemImage: "chevron.left")
                }
                .disabled(isSaving)
            }
        }
        .tint(Color.mamJade)
        .task { await load() }
        .onChange(of: appearance) { _, _ in
            editingChanged()
        }
        .fullScreenCover(isPresented: $showingSelfie) {
            NawalSelfieView(draft: record.draft) { image in
                selfie = image
                preview = image.preparingThumbnail(of: CGSize(width: 1200, height: 1200))
                appearance.photo = PostcardPhotoSettings()
                hasNewPhoto = true
                editingChanged()
            }
        }
        .confirmationDialog("¿Salir sin guardar los cambios?", isPresented: $discardChanges, titleVisibility: .visible) {
            Button("Descartar cambios", role: .destructive) { dismiss() }
            Button("Seguir editando", role: .cancel) {}
        }
        .alert("No se pudo completar la acción", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func editingChanged() {
        confirmation = nil
        didSaveCopy = false
        copyID = UUID()
    }

    @MainActor
    private func load() async {
        guard selfie == nil else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let latest = try await store.load(id: record.id)
            let data = try await store.imageData(id: record.id, asset: .selfie)
            guard !Task.isCancelled else { return }
            guard let image = UIImage(data: data) else { throw PostcardLibraryError.invalidImage }
            record = latest
            appearance = latest.appearance
            originalSelfieData = data
            selfie = image
            preview = image.preparingThumbnail(of: CGSize(width: 1200, height: 1200))
            errorMessage = nil
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    private func save(asCopy: Bool) {
        guard let selfie, !isSaving else { return }
        isSaving = true
        confirmation = nil
        Task { @MainActor in
            defer { isSaving = false }
            do {
                let imageData: Data
                if !hasNewPhoto, let originalSelfieData {
                    imageData = originalSelfieData
                } else {
                    let encoded = await Task.detached(priority: .utility) {
                        PostcardPhotoEncoding.pngData(selfie)
                    }.value
                    guard let encoded else { throw PostcardLibraryError.invalidImage }
                    imageData = encoded
                }
                let rendered = try PostcardExportService.render(
                    draft: record.draft, selfieImage: selfie, appearance: appearance
                )
                let saved: SavedPostcard
                if asCopy {
                    saved = try await store.save(
                        id: copyID, draft: record.draft, appearance: appearance,
                        selfieData: imageData, renderedPNG: rendered.pngData
                    )
                } else {
                    saved = try await store.update(
                        id: record.id, appearance: appearance,
                        selfieData: imageData, renderedPNG: rendered.pngData
                    )
                }
                record = saved
                originalSelfieData = imageData
                hasNewPhoto = false
                didSaveCopy = asCopy
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
                    confirmation = asCopy
                        ? "Copia guardada. Ahora estás editando la copia."
                        : "Tu postal quedó actualizada."
                }
                UIAccessibility.post(notification: .announcement, argument: confirmation)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
