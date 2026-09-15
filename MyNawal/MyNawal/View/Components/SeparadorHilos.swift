import SwiftUI

struct SeparadorHilos: View {
    var body: some View {
        VStack(spacing: 3) {
            Capsule()
                .fill(Color.mamArena)
                .frame(width: 112, height: 1)
            Capsule()
                .fill(Color.mamRojo.opacity(0.75))
                .frame(width: 72, height: 2)
            Capsule()
                .fill(Color.mamArena)
                .frame(width: 112, height: 1)
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}
