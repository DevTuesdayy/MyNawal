import SwiftUI
import UIKit

struct NawalSelfieView: View {
    let draft: NawalPostcardDraft
    let onUsePhoto: (UIImage) -> Void

    @StateObject private var camera = CameraManager()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    @State private var flashOpacity = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.mamFondo.ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("Tómate una selfie")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                        Text("Coloca tu rostro dentro del marco")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Color.mamBlanco.opacity(0.75))
                    }
                    .multilineTextAlignment(.center)

                    cameraSurface
                        .frame(maxWidth: 430)
                        .frame(maxHeight: .infinity)

                    controls
                        .frame(maxWidth: 430)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                .foregroundStyle(Color.mamBlanco)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar", systemImage: "xmark") {
                        dismiss()
                    }
                    .labelStyle(.iconOnly)
                    .accessibilityLabel("Cerrar cámara")
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                camera.prepare()
            }
            .onDisappear {
                camera.stopSession()
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                camera.prepare()
                camera.startSession()
            }
        }
    }

    private var cameraSurface: some View {
        ZStack(alignment: .bottom) {
            Group {
                if let image = camera.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .transition(
                            reduceMotion
                                ? .opacity
                                : .scale(scale: 0.97).combined(with: .opacity)
                        )
                } else {
                    cameraContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

            nawalBadge
                .padding(16)

            Color.white
                .opacity(flashOpacity)
                .allowsHitTesting(false)
        }
        .aspectRatio(3 / 4, contentMode: .fit)
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .strokeBorder(Color.mamAmarillo.opacity(0.8), lineWidth: 2)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .strokeBorder(Color.mamBlanco.opacity(0.35), lineWidth: 1)
                .padding(8)
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.28), radius: 12, y: 8)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var cameraContent: some View {
        switch camera.state {
        case .ready, .capturing:
            CameraPreview(session: camera.session)
                .overlay {
                    if camera.state == .capturing {
                        ProgressView()
                            .tint(Color.mamBlanco)
                            .padding(18)
                            .background(.black.opacity(0.45), in: Circle())
                    }
                }
        case .requestingPermission, .configuring:
            statusView(
                icon: "camera.aperture",
                title: "Preparando cámara",
                message: "Esto tomará sólo un momento.",
                showsProgress: true
            )
        case .denied, .restricted:
            statusView(
                icon: "camera.fill.badge.ellipsis",
                title: "Permiso de cámara necesario",
                message: "Activa el acceso a la cámara para crear tu selfie Nawal.",
                actionTitle: "Abrir Configuración",
                action: openSettings
            )
        case .unavailable:
            statusView(
                icon: "camera.slash",
                title: "Cámara no disponible",
                message: "Prueba esta función en un iPhone con cámara frontal."
            )
        case .failed(let message):
            statusView(
                icon: "exclamationmark.triangle",
                title: "No pudimos abrir la cámara",
                message: message
            )
        case .idle:
            statusView(
                icon: "camera.aperture",
                title: "Preparando cámara",
                message: "Esto tomará sólo un momento.",
                showsProgress: true
            )
        }
    }

    private var nawalBadge: some View {
        HStack(spacing: 12) {
            ImagenNawalLocal(nombre: draft.result.nawal.nombreImagen)
                .frame(width: 58, height: 58)
                .background(Color.mamBlanco, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Mi Nawal")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(Color.mamBlanco.opacity(0.75))
                Text("\(draft.result.energia) \(draft.result.nawal.nombre)")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.black.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.mamAmarillo.opacity(0.55), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mi Nawal es energía \(draft.result.energia), \(draft.result.nawal.nombre)")
    }

    @ViewBuilder
    private var controls: some View {
        if let image = camera.capturedImage {
            HStack(spacing: 12) {
                Button {
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) {
                        camera.clearCapturedImage()
                    }
                    camera.startSession()
                } label: {
                    Label("Repetir", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.bordered)
                .tint(Color.mamBlanco)

                Button {
                    onUsePhoto(image)
                    dismiss()
                } label: {
                    Label("Usar foto", systemImage: "checkmark")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.mamJade)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        } else {
            Button(action: takePhoto) {
                ZStack {
                    Circle()
                        .stroke(Color.mamBlanco, lineWidth: 4)
                        .frame(width: 76, height: 76)
                    Circle()
                        .fill(Color.mamBlanco)
                        .frame(width: 62, height: 62)
                }
                .frame(maxWidth: .infinity, minHeight: 82)
            }
            .buttonStyle(NawalPressStyle())
            .disabled(!camera.state.canCapture)
            .opacity(camera.state.canCapture ? 1 : 0.45)
            .accessibilityLabel("Tomar selfie")
            .accessibilityHint("Captura una fotografía con la cámara frontal")
        }
    }

    private func statusView(
        icon: String,
        title: String,
        message: String,
        showsProgress: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        VStack(spacing: 16) {
            if showsProgress {
                ProgressView()
                    .controlSize(.large)
                    .tint(Color.mamAmarillo)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(Color.mamAmarillo)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(.system(.title3, design: .rounded, weight: .bold))
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color.mamBlanco.opacity(0.75))
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.mamJade)
            }
        }
        .padding(30)
    }

    private func takePhoto() {
        guard camera.state.canCapture else { return }

        if reduceMotion {
            flashOpacity = 0
        } else {
            flashOpacity = 0.82
            withAnimation(.easeOut(duration: 0.24)) {
                flashOpacity = 0
            }
        }

        camera.capturePhoto()
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url)
    }
}

#Preview {
    NawalSelfieView(
        draft: NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        ),
        onUsePhoto: { _ in }
    )
}
