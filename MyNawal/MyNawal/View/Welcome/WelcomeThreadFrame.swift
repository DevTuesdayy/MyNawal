import SwiftUI

/// Abstract thread geometry using the app palette. It does not reproduce or
/// claim a specific traditional textile pattern.
struct WelcomeThreadFrame: View {
    var progress: CGFloat = 1

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .trim(from: 0, to: progress)
                .stroke(Color.mamJade.opacity(0.9), lineWidth: 2)
                .padding(10)

            RoundedRectangle(cornerRadius: 29, style: .continuous)
                .trim(from: 0, to: progress)
                .stroke(Color.mamRojo.opacity(0.78), lineWidth: 1)
                .padding(16)

            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .trim(from: 0, to: progress)
                .stroke(Color.mamArena.opacity(0.95), lineWidth: 2)
                .padding(21)

            VStack {
                WelcomeThreadMotif()
                    .padding(.top, 14)
                Spacer()
                WelcomeThreadMotif()
                    .rotationEffect(.degrees(180))
                    .padding(.bottom, 14)
            }
            .opacity(progress)
            .scaleEffect(progress, anchor: .center)
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}

struct WelcomeThreadMotif: View {
    var progress: CGFloat = 1

    var body: some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(Color.mamJade)
                .frame(width: 44, height: 2)
                .scaleEffect(x: progress, anchor: .trailing)

            diamond(color: .mamRojo, size: 9)
            diamond(color: .mamAmarillo, size: 6)
            diamond(color: .mamRojo, size: 9)

            Capsule()
                .fill(Color.mamJade)
                .frame(width: 44, height: 2)
                .scaleEffect(x: progress, anchor: .leading)
        }
        .opacity(progress)
    }

    private func diamond(color: Color, size: CGFloat) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(45))
    }
}

#Preview {
    WelcomeThreadFrame()
        .frame(width: 390, height: 780)
        .background(Color.mamBlanco)
}
