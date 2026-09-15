import SwiftUI

struct NawalPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.18),
                value: configuration.isPressed
            )
    }
}

private struct NawalEntrance: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared || reduceMotion ? 1 : 0)
            .offset(y: appeared || reduceMotion ? 0 : 8)
            .onAppear {
                // Una sola entrada por instancia; regresar no reinicia la animación.
                guard !appeared else { return }
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.28)) {
                    appeared = true
                }
            }
    }
}

extension View {
    func nawalEntrance() -> some View {
        modifier(NawalEntrance())
    }
}
