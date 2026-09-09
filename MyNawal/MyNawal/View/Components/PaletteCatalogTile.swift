import SwiftUI

struct TarjetaCatalogoNawal: View {
    let nawal: PaletteNawalItem
    let estaSeleccionado: Bool
    let alSeleccionar: () -> Void

    var body: some View {
        Button(action: alSeleccionar) {
            VStack(spacing: 12) {
                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 86)

                Text(nawal.nombre)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(estaSeleccionado ? Color.mamBlanco : Color.mamFondo)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 156)
            .padding(.horizontal, 8)
            .background(estaSeleccionado ? Color.mamJade : Color.white.opacity(0.52))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Nawal \\(nawal.nombre)")
        .accessibilityAddTraits(estaSeleccionado ? .isSelected : [])
    }
}

#Preview {
    TarjetaCatalogoNawal(
        nawal: PaletteNawalItem(nombre: "Imox", esDestacado: true, nombreImagen: "nawal_01"),
        estaSeleccionado: true,
        alSeleccionar: {}
    )
    .padding()
    .background(Color.mamBlanco)
}
