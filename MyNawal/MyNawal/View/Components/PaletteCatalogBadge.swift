import SwiftUI

struct PaletteCatalogBadge: View {
    let title: String
    let background: Color
    let foreground: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(background)
            .clipShape(Capsule())
    }
}
