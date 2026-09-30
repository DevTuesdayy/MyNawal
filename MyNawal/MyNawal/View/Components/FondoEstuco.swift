import SwiftUI

struct FondoEstuco: View {
    @Environment(\.colorSchemeContrast) private var contraste

    var body: some View {
        Color.mamBlanco
            .overlay {
                if contraste != .increased {
                    Image("TexturaEstuco")
                        .resizable(resizingMode: .tile)
                        .opacity(0.75)
                }
            }
            .clipped()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#Preview("Estuco") {
    FondoEstuco()
}
