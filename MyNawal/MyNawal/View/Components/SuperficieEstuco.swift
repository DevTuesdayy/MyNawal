import SwiftUI

struct SuperficieEstuco: ViewModifier {
    func body(content: Content) -> some View {
        let forma = RoundedRectangle(cornerRadius: 18, style: .continuous)
        content
            .background {
                forma.fill(Color.mamBlanco)
                    .overlay { forma.fill(Color.white.opacity(0.38)) }
            }
            .clipShape(forma)
            .overlay { forma.strokeBorder(Color.mamArena.opacity(0.65), lineWidth: 1) }
            .shadow(color: Color.mamFondo.opacity(0.09), radius: 2, x: 0, y: 2)
    }
}

extension View {
    func superficieEstuco() -> some View {
        modifier(SuperficieEstuco())
    }
}
