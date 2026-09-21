import SwiftUI

struct SeparadorHilos: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 3) {
            Capsule()
                .fill(Color.mamArena)
                .frame(width: 112, height: 1)
                .scaleEffect(x: appeared || reduceMotion ? 1 : 0.15, anchor: .leading)
            Capsule()
                .fill(Color.mamRojo.opacity(0.75))
                .frame(width: 72, height: 2)
                .scaleEffect(x: appeared || reduceMotion ? 1 : 0.15, anchor: .trailing)
            Capsule()
                .fill(Color.mamArena)
                .frame(width: 112, height: 1)
                .scaleEffect(x: appeared || reduceMotion ? 1 : 0.15, anchor: .leading)
        }
        .onAppear {
            guard !appeared else { return }
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.45)) {
                appeared = true
            }
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}
