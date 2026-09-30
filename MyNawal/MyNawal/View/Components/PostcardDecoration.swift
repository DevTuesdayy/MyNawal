import SwiftUI

/// Shared vector decoration for the editor thumbnails, preview and exported image.
struct PostcardBackground: View {
    let design: PostcardDesign
    var paper: PostcardPaper = .cream
    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        ZStack {
            switch design {
            case .classic:
                texturedPaper
                LinearGradient(colors: [.mamAmarillo.opacity(0.13), .clear, .mamJade.opacity(0.12)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            case .stone:
                texturedPaper
                Color.white.opacity(0.55)
            case .woven:
                paper.color
            case .minimal:
                paper.color
                Color.white.opacity(0.65)
            }
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private var texturedPaper: some View {
        paper.color.overlay {
            if contrast != .increased {
                Image("TexturaEstuco")
                    .resizable(resizingMode: .tile)
                    .opacity(paper == .cream ? 0.75 : 0.16)
            }
        }.clipped()
    }
}

struct PostcardFrame: View {
    let appearance: PostcardAppearance
    let unit: CGFloat

    private var width: CGFloat { appearance.thickness.width * unit }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24 * unit)
                .strokeBorder(appearance.border,
                              lineWidth: width)

            switch appearance.design {
            case .classic:
                RoundedRectangle(cornerRadius: 18 * unit)
                    .strokeBorder(appearance.ornament.opacity(0.9), lineWidth: width / 2)
                    .padding(7 * unit)
            case .stone:
                RoundedRectangle(cornerRadius: 18 * unit)
                    .strokeBorder(appearance.accent.opacity(0.4), lineWidth: width / 2)
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
            Capsule().fill(appearance.accent).frame(width: width / 3)
            Capsule().fill(appearance.accentColor?.color ?? .mamRojo).frame(width: width / 2)
            Capsule().fill(appearance.frameColor?.color ?? .mamArena).frame(width: width / 3)
        }
    }
}
