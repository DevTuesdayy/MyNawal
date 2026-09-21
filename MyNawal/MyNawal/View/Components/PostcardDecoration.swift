import SwiftUI

/// Shared vector decoration for the editor thumbnails, preview and exported image.
struct PostcardBackground: View {
    let design: PostcardDesign

    var body: some View {
        ZStack {
            switch design {
            case .classic:
                FondoEstuco()
                LinearGradient(colors: [.mamAmarillo.opacity(0.13), .clear, .mamJade.opacity(0.12)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            case .stone:
                FondoEstuco()
                Color.white.opacity(0.55)
            case .woven:
                Color.mamBlanco
            case .minimal:
                Color.mamBlanco.blendMode(.normal)
                Color.white.opacity(0.65)
            }
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}

struct PostcardFrame: View {
    let appearance: PostcardAppearance
    let unit: CGFloat

    private var width: CGFloat { appearance.thickness.width * unit }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24 * unit)
                .strokeBorder(appearance.design == .stone ? Color.mamArena : Color.mamFondo,
                              lineWidth: width)

            switch appearance.design {
            case .classic:
                RoundedRectangle(cornerRadius: 18 * unit)
                    .strokeBorder(Color.mamAmarillo.opacity(0.9), lineWidth: width / 2)
                    .padding(7 * unit)
            case .stone:
                RoundedRectangle(cornerRadius: 18 * unit)
                    .strokeBorder(Color.mamFondo.opacity(0.25), lineWidth: width / 2)
                    .padding(8 * unit)
            case .woven:
                // Abstract thread-like lines, not attributed to a specific traditional motif.
                HStack {
                    threads
                    Spacer(minLength: 0)
                    threads
                }
                .padding(.horizontal, 7 * unit)
                .padding(.vertical, 24 * unit)
            case .minimal:
                EmptyView()
            }
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private var threads: some View {
        HStack(spacing: 2 * unit) {
            Capsule().fill(Color.mamJade).frame(width: width / 3)
            Capsule().fill(Color.mamRojo).frame(width: width / 2)
            Capsule().fill(Color.mamArena).frame(width: width / 3)
        }
    }
}
