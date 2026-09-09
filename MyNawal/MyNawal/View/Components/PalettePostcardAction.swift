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
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
