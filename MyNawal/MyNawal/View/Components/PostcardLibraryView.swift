import SwiftUI

struct PostcardLibraryView: View {
    let store: PostcardLibraryStore

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openURL) private var openURL
    @State private var records: [SavedPostcard] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedPostcard: SavedPostcard?
    @State private var pendingDeletion: SavedPostcard?
    @State private var busyID: UUID?
    @State private var actionError: String?
    @State private var offerSettings = false
    @State private var statusMessage: String?
    @State private var shareImage: LibraryShareImage?
    @State private var reloadID = UUID()

    private var columns: [GridItem] {
        dynamicTypeSize.isAccessibilitySize
            ? [GridItem(.flexible())]
            : [GridItem(.adaptive(minimum: 145, maximum: 240), spacing: 16)]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Tus recuerdos, con tu esencia")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .multilineTextAlignment(.center)
                    SeparadorHilos()

                    if isLoading {
                        ProgressView("Cargando tus postales…")
                            .padding(.vertical, 60)
                    } else if let errorMessage {
                        message(
                            title: "No se pudo abrir la galería",
                            symbol: "exclamationmark.triangle",
                            detail: errorMessage
                        )
                        Button("Volver a intentar") {
                            Task { await reload() }
                        }
                        .buttonStyle(.bordered)
                    } else if records.isEmpty {
                        message(
                            title: "Aquí comienza tu colección",
                            symbol: "rectangle.stack.badge.plus",
                            detail: "Crea una postal y toca “Guardar en Mis postales”. Aquí encontrarás tus diseños."
                        )
                        Button("Volver a Postal") { dismiss() }
                            .buttonStyle(.borderedProminent)
                    } else {
                        summaryLayout {
                            Text(records.count == 1 ? "1 postal" : "\(records.count) postales")
                            Text("Más recientes primero")
                        }
                        .font(.footnote)
                        .accessibilityElement(children: .combine)

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(records) { record in
                                VStack(spacing: 4) {
                                    Button {
                                        selectedPostcard = record
                                    } label: {
                                        PostcardLibraryTile(record: record, store: store)
                                            .id("\(record.id)-\(String(describing: record.updatedAt))")
                                    }
                                    .buttonStyle(NawalPressStyle())
                                    .accessibilityHint("Abre esta postal para editarla")
                                    actions(for: record)
                                }
                                .disabled(busyID != nil)
                            }
                        }
                        .transition(.opacity)
                    }
                }
                .padding(20)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
            .background(FondoEstuco().ignoresSafeArea())
            .foregroundStyle(Color.mamFondo)
            .navigationTitle("Mis postales")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                        .disabled(busyID != nil)
                }
            }
            .refreshable { await reload() }
            .task { await reload() }
        }
        .tint(Color.mamJade)
        .presentationDragIndicator(.visible)
        .presentationDetents([.large])
        .interactiveDismissDisabled(busyID != nil)
        .safeAreaInset(edge: .bottom) {
            if busyID != nil {
                ProgressView("Preparando postal…")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mamBlanco)
            } else if let statusMessage {
                Text(statusMessage)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.mamFondo)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mamBlanco)
                    .transition(.opacity)
            }
        }
        .sheet(item: $selectedPostcard, onDismiss: {
            Task { await reload() }
        }) { record in
            SavedPostcardEditorView(record: record, store: store)
        }
        .sheet(item: $shareImage) { payload in
            LibraryShareSheet(image: payload.image)
        }
        .confirmationDialog(
            "¿Eliminar esta postal de Mis postales?",
            isPresented: Binding(
                get: { pendingDeletion != nil },
                set: { if !$0 { pendingDeletion = nil } }
            ),
            titleVisibility: .visible,
            presenting: pendingDeletion
        ) { record in
            Button("Eliminar postal", role: .destructive) {
                delete(record)
            }
            Button("Cancelar", role: .cancel) {}
        } message: { record in
            Text("Se eliminará \(record.draft.result.energia) \(record.draft.result.nawal.nombre), su foto y sus ajustes de la app. Esta acción no se puede deshacer. Las copias en Fotos permanecerán.")
        }
        .alert("No se pudo completar la acción", isPresented: Binding(
            get: { actionError != nil },
            set: { if !$0 { actionError = nil } }
        )) {
            if offerSettings {
                Button("Abrir Configuración") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                }
            }
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(actionError ?? "")
        }
    }

    private func actions(for record: SavedPostcard) -> some View {
        Menu {
            Button("Editar", systemImage: "slider.horizontal.3") {
                selectedPostcard = record
            }
            Button("Compartir", systemImage: "square.and.arrow.up") {
                export(record, toPhotos: false)
            }
            Button("Guardar en Fotos", systemImage: "square.and.arrow.down") {
                export(record, toPhotos: true)
            }
            Button("Eliminar", systemImage: "trash", role: .destructive) {
                pendingDeletion = record
            }
        } label: {
            Label("Opciones", systemImage: "ellipsis.circle")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .accessibilityLabel("Opciones de \(record.draft.result.energia) \(record.draft.result.nawal.nombre)")
    }

    private func export(_ record: SavedPostcard, toPhotos: Bool) {
        guard busyID == nil else { return }
        busyID = record.id
        statusMessage = nil
        Task { @MainActor in
            defer { busyID = nil }
            do {
                // Use the saved full-resolution render; never export the gallery thumbnail.
                let data = try await store.imageData(id: record.id, asset: .rendered)
                guard let image = UIImage(data: data) else { throw PostcardLibraryError.invalidImage }
                if toPhotos {
                    try await PostcardExportService.saveToPhotoLibrary(data)
                    showStatus("Postal guardada en Fotos.")
                } else {
                    shareImage = LibraryShareImage(image: image)
                }
            } catch {
                report(error)
            }
        }
    }

    private func delete(_ record: SavedPostcard) {
        guard busyID == nil else { return }
        reloadID = UUID()
        busyID = record.id
        statusMessage = nil
        Task { @MainActor in
            defer { busyID = nil }
            do {
                try await store.delete(id: record.id)
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
                    records.removeAll { $0.id == record.id }
                }
                showStatus("Postal eliminada de Mis postales.")
            } catch {
                report(error)
            }
        }
    }

    private func report(_ error: Error) {
        offerSettings = (error as? PostcardExportError) == .photoAccessDenied
        actionError = error.localizedDescription
    }

    private func showStatus(_ message: String) {
        withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
            statusMessage = message
        }
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    private var summaryLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 6))
            : AnyLayout(HStackLayout(spacing: 16))
    }

    private func message(title: String, symbol: String, detail: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: symbol)
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(Color.mamJade)
                .accessibilityHidden(true)
            Text(title)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .accessibilityAddTraits(.isHeader)
            Text(detail).font(.body)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(24)
        .superficieEstuco()
    }

    @MainActor
    private func reload() async {
        guard busyID == nil else { return }
        let requestID = UUID()
        reloadID = requestID
        do {
            let loaded = try await store.list()
            guard !Task.isCancelled, reloadID == requestID else { return }
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
                records = loaded
                errorMessage = nil
                isLoading = false
            }
        } catch {
            guard !Task.isCancelled, reloadID == requestID else { return }
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

private struct LibraryShareImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

/// Presents the system share destinations only when requested for one postcard.
private struct LibraryShareSheet: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

private struct PostcardLibraryTile: View {
    let record: SavedPostcard
    let store: PostcardLibraryStore
    @State private var thumbnail: UIImage?
    @State private var failedToLoad = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Color.mamArena.opacity(0.15)
                .aspectRatio(4.0 / 5.0, contentMode: .fit)
                .overlay {
                    if let thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFit()
                    } else if failedToLoad {
                        Image(systemName: "photo.badge.exclamationmark")
                            .font(.title)
                    } else {
                        ProgressView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)

            Text("\(record.draft.result.energia) \(record.draft.result.nawal.nombre)")
                .font(.system(.headline, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)
            Text(record.createdAt, format: .dateTime.day().month(.abbreviated).year().locale(Locale(identifier: "es_GT")))
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
            if failedToLoad {
                Text("Miniatura no disponible")
                    .font(.caption)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .superficieEstuco()
        .accessibilityElement(children: .combine)
        .task(id: record.id) {
            guard thumbnail == nil else { return }
            do {
                // Load only the 360px asset. Originals stay on disk.
                let data = try await store.imageData(id: record.id, asset: .thumbnail)
                guard !Task.isCancelled else { return }
                thumbnail = UIImage(data: data)
                failedToLoad = thumbnail == nil
            } catch {
                guard !Task.isCancelled else { return }
                failedToLoad = true
            }
        }
        .onDisappear {
            thumbnail = nil
        }
    }
}
