import SwiftUI

struct NawalBackground: View {
    var body: some View {
        ZStack {
            Color.mamCrema

            RadialGradient(
                colors: [Color.mamAmarillo.opacity(0.18), .clear],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 330
            )

            RadialGradient(
                colors: [Color.mamJade.opacity(0.1), .clear],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 290
            )

            GeometryReader { proxy in
                Circle()
                    .stroke(Color.mamJade.opacity(0.07), lineWidth: 1)
                    .frame(width: 280, height: 280)
                    .offset(x: proxy.size.width - 165, y: -150)

                Circle()
                    .stroke(Color.mamOro.opacity(0.08), lineWidth: 1)
                    .frame(width: 210, height: 210)
                    .offset(x: -105, y: proxy.size.height - 80)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NawalBackground()
}
