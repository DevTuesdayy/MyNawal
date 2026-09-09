import SwiftUI

struct PaletteCatalogTile: View {
    let item: PaletteNawalItem

    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(item.isFeatured ? Color.mamJade.opacity(0.16) : Color.white.opacity(0.92))
                .frame(height: 88)
                .overlay {
                    LocalNawalImage(name: item.symbol)
                        .padding(10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(item.isFeatured ? Color.mamJade.opacity(0.85) : Color.mamArena.opacity(0.9), lineWidth: 2)
                        .padding(12)
                }
                .overlay(alignment: .topTrailing) {
                    if item.isFeatured {
                        Circle()
                            .fill(Color.mamAmarillo)
                            .frame(width: 10, height: 10)
                            .padding(10)
                    }
                }

            Text(item.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.mamFondo)
        }
        .padding(12)
        .background(item.isFeatured ? Color.mamBlanco : Color.white.opacity(0.82))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(item.isFeatured ? Color.mamJade.opacity(0.45) : Color.mamArena.opacity(0.75), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    PaletteCatalogTile(
        item: PaletteNawalItem(name: "Imox", isFeatured: true, symbol: "imox")
    )
}
