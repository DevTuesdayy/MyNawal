import SwiftUI

struct PalettePostcardAction: View {
    let title: String
    let icon: String
    let background: Color

    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline.weight(.semibold))
            .foregroundStyle(Color.mamBlanco)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.mamArena, lineWidth: 1)
            }
            .shadow(color: Color.mamFondo.opacity(0.09), radius: 2, x: 0, y: 2)
    }
}
