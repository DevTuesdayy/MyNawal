import SwiftUI

struct PaletteSampleStrip: View {
    let color: Color
    let title: String
    var darkText: Bool = false

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(darkText ? Color.mamFondo : Color.mamBlanco)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
