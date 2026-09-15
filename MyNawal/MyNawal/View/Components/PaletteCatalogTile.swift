import SwiftUI

struct TarjetaCatalogoNawal: View {
    let nawal: PaletteNawalItem
    let estaSeleccionado: Bool
    let alSeleccionar: () -> Void

    private let contorno = RoundedRectangle(cornerRadius: 18, style: .continuous)

    var body: some View {
        Button(action: alSeleccionar) {
            VStack(spacing: 12) {
                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Text(nawal.nombre)
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(estaSeleccionado ? Color.mamBlanco : Color.mamFondo)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .padding(.bottom, 8)
            .background {
                contorno
                    .fill(estaSeleccionado ? Color.mamJade : Color.mamBlanco)
                    .overlay {
                        if !estaSeleccionado {
                            contorno.fill(Color.white.opacity(0.38))
                        }
                    }
            }
            .clipShape(contorno)
            .overlay {
                contorno.strokeBorder(
                    estaSeleccionado ? Color.mamArena : Color.mamArena.opacity(0.65),
                    lineWidth: 1
                )
            }
            .shadow(color: Color.mamFondo.opacity(0.09), radius: 2, x: 0, y: 2)
            .contentShape(contorno)
        }
        .buttonStyle(NawalPressStyle())
        .accessibilityLabel("Nawal \(nawal.nombre)")
        .accessibilityAddTraits(estaSeleccionado ? .isSelected : [])
    }
}

#Preview {
    TarjetaCatalogoNawal(
        nawal: NawalCatalogo.items[0],
        estaSeleccionado: true,
        alSeleccionar: {}
    )
    .padding()
    .background(Color.mamBlanco)
}
